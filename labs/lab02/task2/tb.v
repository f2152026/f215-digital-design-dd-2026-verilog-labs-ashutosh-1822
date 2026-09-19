// tb.v
// Starter testbench template -- YOU complete this file.

module tb;

  // TODO: declare the inputs and outputs
  localparam W = 8;
  localparam D = 8;
  // TODO: instantiate DUT here
  reg  [2:0]   t_sel;
  wire [W-1:0] t_dout;

    integer k;

  lut #(.WIDTH(W), .DEPTH(D)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

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
      t_sel = k;
      #5;
      if (t_dout !== (k*k) % (1 << W))
        $display("  MISMATCH at sel=%0d: got %0d, expected %0d",
                 k, t_dout, (k*k) % (1 << W));
    end
    $finish;
  
  end

  initial
$monitor($time, " sel=%0d | dout=%0d (0x%02h)", t_sel, t_dout, t_dout); // change as required

endmodule
