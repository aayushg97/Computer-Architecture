Design of a sequential circuit which takes a stream of Os and 1s on its input line x and yields an output stream of 0s and 1s on its output line z. The output z is 1 whenever the circuit encounters an odd length block of 0s or an even length block of 1s.

Following gives the output stream for a typical input stream:

        x = 0 0 1 0 0 0 1 1 1 0 1 1 0 0 ...
        z = 0 0 0 0 0 0 1 0 0 0 1 0 1 0 ...
