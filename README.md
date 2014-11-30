# Printer

Code and specifications for out final school project, building a 3D printer.
Written in Posix sh and Arduino C++. Not aiming for Windows compatibility, but
it might work there.

## Printer Communications

The printer listens on serial, receiving characters as commands, followed by
optional parameters. Newlines are ignored. The printer will respond with a 3
letter status code, followed by optional extra info and a newline.

#### Ping

Small check if printer is on and responding.

    > p
    < ack

#### Movement

One of `x`, `y` of `z`, followed by a positive or negative number to be parsed
by `Serial.parseInt()`.

    > x100
    < ok.
    > z-250
    < ok.

#### Printer Head

Actual printing starts with `+` and ends with `-`.

    > +
    < ok.
    > -
    < ok.

