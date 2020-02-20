defmodule FastRSS do
  @moduledoc """
  Documentation parse RSS quickly using a Rust nif.
  """

  defmodule Native do
    use Rustler, otp_app: :fast_rss, crate: "fastrss"

    # When your NIF is loaded, it will override this function.
    def parse(_a), do: :erlang.nif_error(:nif_not_loaded)
  end

  def parse(""), do: {:error, "Cannot parse blank string"}

  def parse(string) when is_binary(string) do
    with {:ok, json} <- Native.parse(string) do
      Jason.decode(json, keys: :atoms)
    end
  end

  def parse(_somethig_else), do: {:error, "Invalid RSS format"}
end
