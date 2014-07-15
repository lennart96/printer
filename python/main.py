#!/usr/bin/env python3

import os
from gi.repository import Gtk
from ui import UI


# ROADMAP:
#      write separate file for printer interaction
#      run all printer interaction separate thread
#      use queue.Queue to report progress on long tasks
#      and disable ui (see end of ui.py)
#      and re enable after thread.join


# REFACT:
#  [ ] Group functions in Window
#  [x] Rename files
#  [ ] Clean this whole file up


# TODO:
#  [ ] Write printer driver
#  [ ] Change title
#  [ ] Decide on printer protocol
#  [ ] Add support for printer status update
#  [ ] Form validation
#  [ ] Separate file for printer head path finding
#  [ ] Implement Load Image
#  [ ] Implement Send
#  [ ] Implement Direct Mode (see Window.cmd)
#  [ ] Remove splitter
#  [ ] Recheck device detection
#  [x] Use icons for control buttons on right side
#      and add them next to text on left side
#  [ ] Decide whether file save/open is useful




DIRECT, BATCH, *_ = range(10, 100)  # control modus

(                                   # REFACT: should probably be in separate file
    UP, DOWN,                       # move head up / down
    NORTH, EAST, SOUTH, WEST,       # move head over surface
    ON, OFF,                        # open/close head
    RESET                           # go back to initial position, close head
) = 'UDNESW+-R'                     # this may change

HEAD = OFF, ON # removes if statement

# partial class
class Window(UI):
    def init(self):
        # called by UI.__init__

        self.mode = BATCH

        cmds = [
            [None,  NORTH,  None],
            [WEST,  RESET,  EAST],
            [DOWN,  SOUTH,  UP  ]
        ]

        for row_cmd, row_btn in zip(cmds, self.buttons):
            for cmd, button in zip(row_cmd, row_btn):
                if cmd is None:
                    continue
                button.connect('clicked', self.generate_callback(cmd))

        # temporary; future versions may assign different functionality
        self.buttons[0][0].connect('clicked', self.clear_batch)

    def batch_text(self):
        return self.batch_buffer.get_text(
            *self.batch_buffer.get_bounds(),
            include_hidden_chars=True
        )

    def clear_batch(self, *_):
        'clear batch mode text field'
        self.batch_buffer.set_text('')

    def generate_callback(self, cmd):
        'generate a callback for command buttons'
        def callback(*_):
            self.cmd(cmd)

        return callback

    def cmd(self, symbol):
        'append to batch text or control directly depending on current mode'
        if self.mode is BATCH or 1:
            end = self.batch_buffer.get_end_iter()
            self.batch_buffer.insert(end, symbol)

    def toggle_head(self, switch, g):
        # called when head ON/OFF switch changes
        active = switch.get_active()
        if self.mode is BATCH:
            if active != self.batch_is_down():
                self.cmd(HEAD[active])
        else:
            self.cmd(HEAD[active])

    def batch_is_down(self):
        'is the last action in batch mode an ON command'
        cmds = self.batch_text()
        return cmds.rfind(ON) > cmds.rfind(OFF)

    def on_text_changed(self, sender):
        # called when batch text field changed
        if self.mode is BATCH:
            self.button_head.set_active(
                self.batch_is_down())

    def set_mode(self, switch, _):
        # called when user switches mode
        # if no more code added change to inline if

        if switch.get_active():
            self.mode = DIRECT
        else:
            self.mode = BATCH

    def get_printer(self):
        # TODO: find out how this works on non-unix

        dev = self.select_device.get_child().get_text()
        dev = os.path.expandvars(dev)
        if not os.path.isabs(dev):
            dev = os.path.join('/dev', dev)
        return dev

    def scan_printers(self, *_):
        # TODO: find out how this works on non-unix

        self.serials.clear()

        # ONLY IN DEBUG:
        self.serials.append(['ttyUSB0'])

        try:
            for dev in os.listdir('/dev'):
                if dev[:6] in ('ttyUSB', 'ttyACM'):
                    self.serials.append([dev])
        except FileNotFoundError:
            pass




def main():
    window = Window()
    window.connect("delete-event", Gtk.main_quit)
    window.show_all()
    Gtk.main()

if __name__ == '__main__':
    main()
