package main

import (
	"fmt"
	"os"
	"os/exec"
	"syscall"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"

	"github.com/docker/cli/cli"
	"github.com/docker/cli/cli/command"
	"github.com/docker/cli/cli/command/container"
)

func main() {
	dockerCli, err := command.NewDockerCli()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	// There are a few conflicts between commonFlags and runFlags:
	//
	//    docker -c CONTEXT run ...
	//    docker run -c CPU_SHARES ...
	//
	//    docker -l LOGLEVEL run ...
	//    docker run -l LABELLIST ...
	//
	// Which should "-c" and "-l" each be short for?
	//
	// I'm going for letting "-c" be short for "--cpu-shares"
	// instead of for "--context", and for letting "-l" be short
	// for "--label" instead of "--log-level".

	_, rawCommonFlags, _ := cli.SetupRootCommand(&cobra.Command{})
	commonCmd := &cobra.Command{}
	commonFlags := commonCmd.Flags()
	rawCommonFlags.VisitAll(func(flag *pflag.Flag) {
		// If you want to intercept or modify any flags, do
		// that here, as we do for --context.
		if flag.Shorthand == "c" || flag.Shorthand == "l" {
			flag.Shorthand = ""
		}
		commonFlags.AddFlag(flag)
	})

	rawRunFlags := container.NewRunCommand(dockerCli).Flags()
	runCmd := &cobra.Command{}
	runFlags := runCmd.Flags()
	rawRunFlags.VisitAll(func(flag *pflag.Flag) {
		// If you want to intercept or modify any flags, do
		// that here.
		runFlags.AddFlag(flag)
	})

	cmd := &cobra.Command{
		Use:                   "docker-run-wrapper [OPTIONS] PATH | URL | -",
		Short:                 "A wrapper around `docker run`",
		Args:                  cli.ExactArgs(1),
		SilenceUsage:          true, // We handle this in cli.FlagErrorFunc()
		SilenceErrors:         true, // We handle this after cmd.Execute() returns
		DisableFlagsInUseLine: true, // We write "[OPTIONS]" instead of "[flags]"
		RunE: func(cmd *cobra.Command, runArgs []string) error {
			var dockerOptions []string
			var runOptions []string
			cmd.Flags().Visit(func(flag *pflag.Flag) {
				switch flag.Name {
				// If you added flags, handle them here.
				//case "myflag":
				//	str := flag.Value.String()
				default:
					if commonFlags.Lookup(flag.Name) != nil {
						dockerOptions = append(dockerOptions, "--"+flag.Name+"="+flag.Value.String())
					} else if runFlags.Lookup(flag.Name) != nil {
						runOptions = append(runOptions, "--"+flag.Name+"="+flag.Value.String())
					} else {
						panic(errors.Errorf("could not categorize flag %v", flag))
					}
				}
			})

			var cmdline []string
			cmdline = append(cmdline, "docker")
			cmdline = append(cmdline, dockerOptions...)
			cmdline = append(cmdline, "run")
			cmdline = append(cmdline, runOptions...)
			cmdline = append(cmdline, runArgs...)

			ecmd := exec.Command(cmdline[0], cmdline[1:]...)
			ecmd.Stdout = os.Stdout
			ecmd.Stderr = os.Stderr

			if err := ecmd.Run(); err != nil {
				if ee, ok := err.(*exec.ExitError); ok {
					err = cli.StatusError{
						StatusCode: ee.ProcessState.Sys().(syscall.WaitStatus).ExitStatus(),
					}
				}
				return err
			}

			return nil
		},
	}
	cmd.Flags().AddFlagSet(commonFlags)
	cmd.Flags().AddFlagSet(runFlags)

	cmd.SetFlagErrorFunc(cli.FlagErrorFunc)
	cmd.SetHelpTemplate(helpTemplate)
	cmd.SetUsageTemplate(usageTemplate)
	cobra.AddTemplateFunc("commonCmd", func() *cobra.Command { return commonCmd })
	cobra.AddTemplateFunc("runCmd", func() *cobra.Command { return runCmd })

	if err := cmd.Execute(); err != nil {
		if sterr, ok := err.(cli.StatusError); ok {
			if sterr.Status != "" {
				fmt.Fprintln(dockerCli.Err(), sterr.Status)
			}
			// StatusError should only be used for errors, and all errors should
			// have a non-zero exit status, so never exit with 0
			if sterr.StatusCode == 0 {
				os.Exit(1)
			}
			os.Exit(sterr.StatusCode)
		}
		fmt.Fprintln(dockerCli.Err(), err)
		os.Exit(1)
	}
}

// helpTemplate is borrowed from github.com/docker/cli/cli/cobra.go
const helpTemplate = `
{{if or .Runnable .HasSubCommands}}{{.UsageString}}{{end}}`

// usageTemplate is based on the one in github.com/docker/cli/cli/cobra.go
const usageTemplate = `Usage:

{{- if not .HasSubCommands}}	{{.UseLine}}{{end}}

{{if ne .Long ""}}{{ .Long | trim }}{{ else }}{{ .Short | trim }}{{end}}

Options for "docker":
{{ commonCmd | wrappedFlagUsages | trimRightSpace}}

Options for "docker run":
{{ runCmd | wrappedFlagUsages | trimRightSpace}}
`
