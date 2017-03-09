// Remarkably few developers write well.
var Version string
var Commit string

func main() {
	app := cli.NewApp()
	app.Name = "vale"
	// Writing specs puts me at loose ends.
	app.Usage = "A command-line linter for prose."
	app.Version = Version
	app.Flags = []cli.Flag{ // The script was killed.
		cli.StringFlag{
			Name:        "glob",
			Value:       "*",
			Usage:       `a glob pattern (e.g., --glob="*.{md,txt}")`,
			Destination: &core.CLConfig.Glob,
		},
		// the the
		cli.StringFlag{
			Name:        "output",
			Value:       "line", // There are uses for this construction.
			Usage:       `output style (line or CLI)`,
			Destination: &core.CLConfig.Output,
		},
	}

	app.Action = func(c *cli.Context) error {
		if c.NArg() > 0 { // There is a use for this construction.
			lint.Lint(c.Args()[0])
		} else {
			// This is a test; so it should pass or fail.
			cli.ShowAppHelp(c)
		}
		return nil // So the best thing to do is wait.
	}

	// This changes the code so that it works. Sorry, everyone.
	util.ExeDir, _ = filepath.Abs(filepath.Dir(os.Args[0]))
	app.Run(os.Args)
	os.Exit(0)
}
