#!/usr/bin/env python3

"""TinyWM (fkbm flavour)

A rewrite of Nick Welch's tinywm.
"""

import importlib
import shlex
import subprocess
import sys
import traceback

from Xlib import X, XK
from Xlib.display import Display
from Xlib.protocol.event import ClientMessage
from Xlib.protocol.request import InternAtom


class TinyWM:

    MOD_MASK = X.Mod4Mask

    RUN_COMMAND = "gmrun"
    TERMINAL_COMMAND = "x-terminal-emulator"

    KEY_MAP = {
        "r": "spawn_run",
        "q": "close_client",
        "Return": "spawn_terminal",
        "F1": "raise_client",
        "F2": "lower_client",
        "F4": "stop",
        "F10": "maximize",
        "F11": "maximize_left",
        "F12": "maximize_right",
    }

    def __init__(self):
        self.dpy = None
        self.keys = {}
        self.root = None
        self._done = False

    def start(self):
        mod = self.MOD_MASK
        dpy = Display()

        keys = {}
        for key, name in self.KEY_MAP.items():
            keys[key] = dpy.keysym_to_keycode(XK.string_to_keysym(key))

        root = dpy.screen().root
        for key, code in keys.items():
            root.grab_key(code, mod, 1, X.GrabModeAsync, X.GrabModeAsync)

        root.grab_button(1, mod, 1, X.ButtonPressMask|X.ButtonReleaseMask|X.PointerMotionMask,
                         X.GrabModeAsync, X.GrabModeAsync, X.NONE, X.NONE)
        root.grab_button(3, mod, 1, X.ButtonPressMask|X.ButtonReleaseMask|X.PointerMotionMask,
                         X.GrabModeAsync, X.GrabModeAsync, X.NONE, X.NONE)

        self.dpy = dpy
        self.keys = keys
        self.root = root

        self.WM_PROTOCOLS = dpy.intern_atom("WM_PROTOCOLS")
        self.WM_DELETE_WINDOW = dpy.intern_atom("WM_DELETE_WINDOW")

        self._loop()

    def stop(self, event):
        self._done = True

    def spawn_run(self, event):
        subprocess.Popen(shlex.split(self.RUN_COMMAND))

    def spawn_terminal(self, event):
        subprocess.Popen(shlex.split(self.TERMINAL_COMMAND))

    def raise_client(self, event):
        if not event.child:
            return

        event.child.configure(stack_mode=X.Above)

    def lower_client(self, event):
        if not event.child:
            return

        event.child.configure(stack_mode=X.Below)

    def close_client(self, event):
        if not event.child:
            return

        cm_event = ClientMessage(window=event.child, client_type=self.WM_PROTOCOLS,
                                 data=(32, [self.WM_DELETE_WINDOW, X.CurrentTime, 0, 0, 0]))
        event.child.send_event(cm_event)

    def maximize(self, event):
        if not event.child:
            return

        geom = self.root.get_geometry()
        event.child.configure(x=0, y=0, width=geom.width, height=geom.height)

    def maximize_left(self, event):
        if not event.child:
            return

        geom = self.root.get_geometry()
        event.child.configure(x=0, y=0, width=int(geom.width/2), height=geom.height)

    def maximize_right(self, event):
        if not event.child:
            return

        geom = self.root.get_geometry()
        event.child.configure(x=0, y=0, width=int(geom.width/2), height=geom.height)
        cgeom = event.child.get_geometry()
        event.child.configure(x=geom.width-cgeom.width, y=0, width=cgeom.width, height=cgeom.height)

    def _loop(self):
        self._done = False
        start = None
        start_geometry = None
        while not self._done:
            try:
                event = self.dpy.next_event()

                if event.type == X.KeyPress:
                    self._key_press(event)
                elif event.type == X.ButtonPress and event.child != X.NONE:
                    start = event
                    start_geometry = event.child.get_geometry()
                elif event.type == X.MotionNotify and start:
                    self._mouse_motion_client(event, event.child, start, start_geometry)
                elif event.type == X.ButtonRelease:
                    start = None

            except Exception as error:
                sys.stderr.write(str(error))
                sys.stderr.write(traceback.format_exc())
                sys.stderr.flush()

    def _key_press(self, event):
        for key_name, func_name in self.KEY_MAP.items():
            if event.detail == self.keys[key_name]:
                func = getattr(self, func_name)
                func(event)

    def _mouse_motion_client(self, event, client, start, geom):
        xdiff = event.root_x - start.root_x
        ydiff = event.root_y - start.root_y
        start.child.configure(
            x=geom.x + (start.detail == 1 and xdiff or 0),
            y=geom.y + (start.detail == 1 and ydiff or 0),
            width=max(1, geom.width + (start.detail == 3 and xdiff or 0)),
            height=max(1, geom.height + (start.detail == 3 and ydiff or 0)))


def main():
    tinywm = TinyWM()
    tinywm.start()


if __name__ == '__main__':
    main()
