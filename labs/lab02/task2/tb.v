// tb.v
// Starter testbench template -- YOU complete this file.

module tb;

  // TODO: declare the inputs and outputs
  localparam W = 8;
  localparam D = 8;
  // TODO: instantiate DUT here
  reg  [2:0]   t_sel;
  wire [W-1:0] t_dout;

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
    for (k = 0; k < D; k = k + 1) begin
      t_sel = k[2:0];
      #5;
      if (t_dout !== (k*k) % (1 << W))
        $display("  MISMATCH at sel=%0d: got %0d, expected %0d",
                 k, t_dout, (k*k) % (1 << W));
    end
    $finish;
  
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y); // change as required

endmodule
