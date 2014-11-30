# Printer

Code and specifications for out final school project, building a 3D printer.
Written in Posix sh and Arduino C++. Not aiming for Windows compatibility, but
it might work there.

## Printer Communications

The printer listens on serial, receiving a single uppercase letters as
commands, followed by optional parameters. Newlines are ignored. The printer
will respond with a 3 uppercase letter status code, followed by optional extra
info and a newline.

### Implemented commands

#### Ping

Small check if printer is on and responding.

    >P
    <ACK

#### Movement

One of `X`, `Y` of `Z`, followed by a positive or negative number to be parsed
by `Serial.parseInt()`.

    >X100
    <OK.
    >Z-250
    <OK.

#### Printer Head

Actual printing starts with `+` and ends with `-`.

    >+
    <OK.
    >-
    <OK.

