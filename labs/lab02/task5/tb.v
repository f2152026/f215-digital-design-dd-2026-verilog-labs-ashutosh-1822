
module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] expected;
  integer    ia, ib, iop;
  integer    errors, tests;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  
  task check;
    input [3:0] va, vb;
    input       vop;
    begin
      t_a = va; t_b = vb; t_op = vop;
      #5;
      expected = vop ? (va - vb) : (va + vb);
      tests = tests + 1;
      if (t_result !== expected) begin
        $display("FAIL t=%0t: a=%0d b=%0d op=%b (%s)  got=%0d  expected=%0d",
                 $time, va, vb, vop, vop ? "sub" : "add", t_result, expected);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0; tests = 0;

    // Phase 1
    $display("-- Phase 1: fixed operands, op toggling --");
    check(4'd9, 4'd4, 1'b0);
    check(4'd9, 4'd4, 1'b1);
    check(4'd9, 4'd4, 1'b0);
    check(4'd7, 4'd2, 1'b1);
    check(4'd7, 4'd2, 1'b0);

    // Phase 2
    $display("-- Phase 2: sweeping operands --");
    for (iop = 0; iop < 2; iop = iop + 1)
      for (ia = 0; ia < 16; ia = ia + 1)
        for (ib = 0; ib < 16; ib = ib + 1)
          check(ia[3:0], ib[3:0], iop[0]);

    $write("SUMMARY: %0d/%0d passed", tests - errors, tests);
    if (errors == 0) $write(" -- ALL PASS\n");
    else             $write(" -- %0d FAILURE(S)\n", errors);
    $finish;
  end

endmodule