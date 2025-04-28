module fac (
  input b,
  input a,
  input cin,
  output sum,
  output cout
);
  assign sum = (b ^ a ^ cin);
  assign cout = ((b & a) | (b & cin) | (a & cin));
endmodule