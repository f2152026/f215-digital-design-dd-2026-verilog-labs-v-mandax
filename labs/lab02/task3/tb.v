// tb.v

module tb;

  reg  [1:0] t_a;
  reg  [1:0] t_b;

  wire t_gt;
  wire t_lt;
  wire t_eq;

  integer a, b;
  integer errors;
  integer total;

  reg exp_gt;
  reg exp_lt;
  reg exp_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration

  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin

    errors = 0;
    total  = 0;

    for (a = 0; a < 4; a = a + 1) begin
      for (b = 0; b < 4; b = b + 1) begin

        t_a = a;
        t_b = b;

        #1;

        exp_gt = (a > b);
        exp_lt = (a < b);
        exp_eq = (a == b);

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display(
            "FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
            $time,
            t_a, t_b,
            t_gt, t_lt, t_eq,
            exp_gt, exp_lt, exp_eq
          );
          errors = errors + 1;
        end

        total = total + 1;

      end
    end

    $write("SUMMARY: ");
    $display("%0d passed, %0d failed, total=%0d",
             total-errors, errors, total);

    $finish;

  end

  initial
    $monitor($time,
             " A=%b B=%b | GT=%b LT=%b EQ=%b",
             t_a, t_b, t_gt, t_lt, t_eq);


endmodule