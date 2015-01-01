#!/usr/bin/python

from threading import Thread
from time import sleep
import subprocess as proc
from gi.repository import Gtk, Pango, Gdk

class Exec(Thread):
    def __init__(self, cmd, print):
        super().__init__()
        self.print = print
        self.cmd = cmd

    def run(self):
        p = proc.Popen(self.cmd, stdout=proc.PIPE, stderr=proc.PIPE)
        for line in p.stdout:
            Gdk.threads_enter()
            self.print(line.decode("latin1"))
            Gdk.threads_leave()
            sleep(0.01)
        self.print(p.stderr.read().decode("latin1"))
        self.print('done.')

def exec(print, *cmd):
    Exec(cmd, print).start()

class Window(Gtk.Window):
    def __init__(self):
        super().__init__(title="Printer Control")
        self.set_default_size(400, 400)
        main = Gtk.VBox()
        output = self.create_output()
        control = self.create_control()
        main.pack_start(control, False, False, 0)
        main.pack_start(output, True, True, 0)
        self.add(main)

    def create_settings(self, box):
        def validate(entry):
            if entry.get_text().isdigit():
                entry.modify_bg(Gtk.StateType.NORMAL, Gdk.Color(65535, 65535, 65535))
            else:
                entry.modify_bg(Gtk.StateType.NORMAL, Gdk.Color(65535, 0,     0))
        def add(name, text="0"):
            label = Gtk.Label(name + ":")
            widget = Gtk.Entry()
            widget.set_text(str(text))
            widget.set_max_width_chars(6)
            widget.set_width_chars(6)
            widget.connect("changed", validate)
            box.pack_start(label, False, False, 0)
            box.pack_start(widget, False, False, 0)
        add("steps x", 100)
        add("steps y", 100)
        add("steps z", 100)

    def create_output(self):
        self.output = Gtk.TextView()
        self.output.modify_font(Pango.FontDescription("monospace 12"))
        self.output.set_editable(False)
        return self.output

    def print(self, text):
        buf = self.output.get_buffer()
        end = buf.get_end_iter()
        buf.insert(end, text+"\n")

    def create_control(self):
        self.control = Gtk.HBox()
        self.control_image = self.create_image()
        self.control.pack_start(self.control_image, False, False, 0)
        self.create_settings(self.control)
        return self.control

    def create_image(self):
        button = Gtk.Button(label="print")
        button.connect("clicked", self.upload_image)
        return button

    def upload_image(self, _):
        files = Gtk.FileFilter()
        files.set_name("Images")
        files.add_pattern("*.png")
        dialog = Gtk.FileChooserDialog("Print Image"
                                      ,self
                                      ,Gtk.FileChooserAction.OPEN
                                      ,(Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL
                                       ,Gtk.STOCK_OK,     Gtk.ResponseType.OK)
                                      )
        dialog.add_filter(files)
        if (dialog.run() == Gtk.ResponseType.OK):
            self.print_file(dialog.get_filename())
        dialog.destroy()

    def print_file(self, path):
        self.print("printing %r" % path)
        cmd = ("fromPng %r | path %r %r %r | send-cmd %r -i" % (
            path,
            self.getX(),
            self.getY(),
            self.getZ(),
            self.getPort()))
        print("exec " + cmd)
        exec(self.print, "sh", "-c", cmd)

    def getX(self):
        return "100"

    def getY(self):
        return "100"

    def getZ(self):
        return "100"

    def getPort(self):
        return '/dev/ttyACM0'

Gdk.threads_init()
window = Window()
window.connect("delete-event", Gtk.main_quit)
window.show_all()
Gdk.threads_enter()
Gtk.main()
Gdk.threads_leave()
