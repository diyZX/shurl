defmodule Shurl.Repo do
  use Ecto.Repo, otp_app: :shurl
  alias Shurl.Repo

  def trans(func) do
    with {:ok, result} <- Repo.transaction(func), do: result
  end
end
