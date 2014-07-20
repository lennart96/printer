from gi.repository import Gtk, Pango


bauds = [   300 ,    600 ,    1200 ,   2400 ,   4800 ,
           9600 ,  14400 ,   19200 ,  28800 ,  31250 ,
          38400 ,  57600 ,  115200                   ]


def img(icon='about', label=None):
    'create button with stock icon'
    icon = getattr(Gtk, 'STOCK_'+icon.upper())
    icon = Gtk.Image.new_from_stock(
        icon, Gtk.IconSize.BUTTON
    )
    button = Gtk.Button()
    button.set_image(icon)
    if label:
        button.set_label(label)
    return button


# partial class
class UI(Gtk.Window):
    def __init__(self):
        # :( python 2
        super(Gtk.Window, self).__init__(title="Printer Driver")
        self.init_ui()
        self.init()


    def init_ui(self):

        #      left            right
        # +---------------+-------------+
        # | other buttons |             |
        # |---------------|  settings   |
        # |               |             |
        # |   batch       |-------------|
        # |   mode        |             |
        # |   text        |  control    |
        # |   field       |  buttons    |
        # |               |             |
        # |               |             |
        # +---------------+-------------+


        left = self.create_batch()      # batch text field
        right = self.create_control()   # control and settings

        self.main = Gtk.Paned()
        self.main.pack1(left,  resize=True,  shrink=True)
        self.main.pack2(right, resize=False, shrink=False)
        self.add(self.main)


    # left pane

    def create_batch(self):
        top = Gtk.HBox(spacing=4)
        self.button_load = img('open', ' Load Heightmap')
        self.button_send = img('media_play', ' Run')
        top.add(self.button_load)
        top.add(self.button_send)

        self.batch_input = Gtk.TextView()
        self.batch_input.modify_font(Pango.FontDescription("monospace 12"))
        self.batch_input.set_wrap_mode(Gtk.WrapMode.CHAR)

        self.batch_buffer = self.batch_input.get_buffer()
        self.batch_buffer.connect('changed', self.on_text_changed)

        left = Gtk.VBox(spacing=4)
        left.pack_start(top, False, True, 0)
        left.pack_start(self.batch_input, True, True, 0)

        return left


    # right pane

    def create_control(self):
        self.create_settings()
        self.create_buttons()

        table = Gtk.Table(10, 6, True)

        #                                   horizontal  vertical

        # device selection
        table.attach(self.label_device,     0,  2,      0,  1   )
        table.attach(self.select_device,    2,  5,      0,  1   )
        table.attach(self.scan_button,      5,  6,      0,  1   )

        # baud ratio selection
        table.attach(self.label_baud,       0,  2,      1,  2   )
        table.attach(self.select_baud,      2,  6,      1,  2   )

        # set mode
        table.attach(self.label_mode,       0,  2,      2,  3   )
        table.attach(self.button_mode,      2,  4,      2,  3   )

        # control buttons
        for y, row in enumerate(self.buttons):
            for x, cell in enumerate(row):
                l = 2*x
                t = 4+y*2
                table.attach(cell,          l,  l+2,    t,  t+2
                     ,xpadding=4
                     ,ypadding=4
                )

        # hack to make table unresizable
        # there must be a better way to do this

        grid = Gtk.Grid()
        grid.add(table)
        return grid

    # upper right pane

    def create_settings(self):
        def combobox(model):
            c = Gtk.ComboBox.new_with_model_and_entry(model)
            c.set_entry_text_column(0)
            return c


        # labels
        # TODO: find a way to align labels to the left of GtkTable
        self.label_baud = Gtk.Label('Baud Rate')
        self.label_device = Gtk.Label('Device')
        self.label_mode = Gtk.Label('Direct Control')

        # baud rate selection
        self.default_bauds = Gtk.ListStore(str)
        for baud in bauds: self.default_bauds.append([str(baud)])

        self.select_baud = combobox(self.default_bauds)
        self.select_baud.set_active(bauds.index(9600))

        # device selection
        self.serials = Gtk.ListStore(str)

        self.select_device = combobox(self.serials)
        self.scan_printers() # not very mvc
        self.select_device.set_active(0)

        self.scan_button = img("refresh")
        self.scan_button.connect("clicked", self.scan_printers)

        # mode switch
        self.button_mode = Gtk.Switch()


    # lower right pane

    def create_buttons(self):
        btn = lambda lbl:Gtk.Button(label=lbl)

        self.button_head = switch = Gtk.Switch()
        self.buttons = (
            (btn('Clear'),      img('go_up'),       switch),
            (img('go_back'),    img('undo'),        img('go_forward')),
            (btn('Down'),       img('go_down'),     btn('Up')),
        )

        self.button_head.connect('notify::active', self.toggle_head)
        self.button_mode.connect('notify::active', self.set_mode)


    # not the way to go
    # keeping it as reference

    def control(self):
        return self._control(self)

    class _control:
        def __init__(_, self):
            _.self = self

        def __enter__(_):
            _.self.main.set_sensitive(False)

        def __exit__(_,*__):
            _.self.main.set_sensitive(True)


# TODO: should probaply remove in production code
if __name__ == '__main__':
    import main
    main.main()
