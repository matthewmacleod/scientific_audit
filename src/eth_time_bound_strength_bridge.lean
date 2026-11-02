import Mathlib

namespace ETHTimeBoundStrength

/--
Once the log-log factor is at least one, a bound with one
log-log factor is no larger than the corresponding bound with
two log-log factors.
-/
theorem single_loglog_le_squared_loglog
    {base t : ℝ}
    (hbase : 0 ≤ base)
    (ht : 1 ≤ t) :
    base * t ≤
      base * t ^ 2 := by

  have htt :
      t ≤ t ^ 2 := by
    nlinarith [mul_nonneg (show 0 ≤ t by linarith)
      (show 0 ≤ t - 1 by linarith)]

  exact
    mul_le_mul_of_nonneg_left
      htt
      hbase

end ETHTimeBoundStrength
