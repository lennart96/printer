# Printer

Code and specifications for our final school project, building a 3D printer.
Written in Posix sh, Arduino C++, c89 and Haskell. Not aiming for Windows compatibility, but
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

#### State

Some small commands to make commanding the printer directly easier. A reference point is implemented to which the printer will returen when commanded to. The reference point is disabled by default.

Setting state is done using a `!` prefix, getting current state or other information using `?`. The reference point is referred to as `0`, the x, y, and z positions as respectively `x`, `y` and `z`.

Example:

    > !x400                         -- try to set x position to 400
    < err reference point not set
    > !0                            -- set reference point as current location
    < ok.
    > !x400                         -- set x position to 400
    < ok.
    > ?0
    < set ref.on yes                -- reference point is set
    > ?x                            -- get current x position
    < set pos.x 400
