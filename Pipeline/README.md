FOLLOWING ISA SPECIFICATION IS MODIFIED TO ACCOMMODATE PIPELINING :-


  push rm : sp <= sp-1; M[sp] <= rm;

  pop rm : rm <= M[sp]; sp <= sp + 1;

  add rm : rm <= rm + M[sp]; sp <= sp + 1;

  neg rm : rm <= -M[sp]; sp <= sp + 1   --- two's complement provides the negated value;

  or rm : rm <= rm | M[sp]; sp <= sp + 1; --- bit-wise or

  not rm : rm <= bit-wise complement of M[sp]; sp <= sp + 1;

Corresponding to add, neg, or, not instructions, four flags are decided namely, carry (c), zero (z), overflow (v) and sign (s) based on the result of the operation; thus, after add operation, s <- 1 if the alu output is less than 0.

  b<cc> label : if conditions[cc] = 1 then PC <= PC + label, where cc specifies the desired condition code to choose from the set {unconditional, carry (c), not carry (nc), zero (z), not zero (nz), overflow (v), not overflow (nv), sign (s), not sign (ns)} as decided by the most recently executed ALU instruction; it is assumed that immediately after fetching of an instruction, PC is incremented (by 1 -- since there is no provision of accessing bytes).

  call label : sp <= sp - 1; M[sp] <= PC; PC <= PC + label; again, it is assumed that PC is incremented by 1 immediately after fetching the instruction.

  ret : PC <= M[sp]; sp <= sp + 1;
