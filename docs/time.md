# Time

## Clock

- `Clock.Now()` returns monotonic elapsed-time seconds from os.clock.
- `Clock.Unix()` and `Clock.UnixMilliseconds()` return wall-clock Unix time.
- `Clock.Measure(callback)` returns elapsed seconds followed by the callback's results.
- `Clock.Sleep(seconds)` waits and returns actual elapsed time.

Use Now for measuring durations. Unix time is wall-clock time and can change with system clock adjustments.

## Duration

`Duration.new(seconds)` stores a duration in seconds.

- `:Seconds()`, `:Milliseconds()`, `:Minutes()`, `:Hours()`
- `:Add(other)`, `:Sub(other)`, `:Scale(factor)`, `:ToString()`

## Timer

`Timer.new()` creates a stopped timer.

- `:Start()`, `:Stop()`, `:Reset()`, `:Restart()`
- `:Elapsed()`, `:IsRunning()`

Timer uses os.clock and does not yield.
