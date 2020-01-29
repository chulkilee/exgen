defmodule Mix.Tasks.Exgen.New do
  use Mix.Task
  import Exgen.Util
  alias Exgen.Command

  @shortdoc "Generate a new project from a template"

  @moduledoc """
  Generate a new project from an Exgen template

      $ mix exgen.new ./new_app https://github.com/rwdaigle/exgen-plug-simple.git
  """
  def run(args) do
    with {:ok, target, opts} <- parse_args(args),
         {:ok, template_path} <- resolve_template(opts),
         {:ok, command} <- Command.load(template_path, target, opts) do
      command |> Command.New.run()
    else
      {:error, error} when is_binary(error) -> Mix.shell().error(error)
      {:error, error} -> Mix.shell().error(inspect(error))
    end
  end

  def parse_args(args) do
    {opts, args, _} =
      OptionParser.parse(args,
        switches: [template: :string, template_subdir: :string],
        aliases: [t: :template],
        allow_nonexistent_atoms: true
      )

    default_opts = []
    opts = Keyword.merge(default_opts, opts)
    target = Enum.at(args, 0)

    {:ok, target, opts}
  end

  defp resolve_template(opts) do
    template = Keyword.fetch!(opts, :template)
    template_subdir = Keyword.get(opts, :template_subdir, "")

    cond do
      String.ends_with?(template, ".git") ->
        tmp_dir = in_tmp(fn -> System.cmd("git", ["clone", template, "exgen"]) end)
        {:ok, Path.join([tmp_dir, "exgen", template_subdir])}

      true ->
        {:ok, Path.join([template, template_subdir])}
    end
  end
end
