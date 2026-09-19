
module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  reg        exp_gt, exp_lt, exp_eq;
  integer    ia, ib;
  integer    errors, tests;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    tests  = 0;

    for (ia = 0; ia < 4; ia = ia + 1) begin
      for (ib = 0; ib < 4; ib = ib + 1) begin

        t_a = ia;
        t_b = ib;
        #5;

    
        exp_gt = (ia >  ib);
        exp_lt = (ia <  ib);
        exp_eq = (ia == ib);

        tests = tests + 1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    $write("SUMMARY: %0d/%0d combinations passed", tests - errors, tests);
    if (errors == 0)
      $write(" -- ALL PASS\n");
    else
      $write(" -- %0d FAILURE(S)\n", errors);

    $finish;
  end

endmodule