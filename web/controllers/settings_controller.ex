defmodule ExMoney.SettingsController do
  use ExMoney.Web, :controller

  alias ExMoney.SessionController
  alias Guardian.Plug.EnsureAuthenticated
  alias ExMoney.Login
  alias ExMoney.Account
  alias ExMoney.Repo

  plug EnsureAuthenticated, %{ on_failure: { SessionController, :new } }

  def logins(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    logins = Login.by_user_id(user.id) |> Repo.all
    render conn, "logins.html", logins: logins, navigation: "logins", topbar: "settings"
  end

  def accounts(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    login_ids = Login.by_user_id(user.id)
    |> Repo.all
    |> Enum.map(fn(login) -> login.saltedge_login_id end)

    accounts = Account.by_saltedge_login_id(login_ids) |> Repo.all

    render conn, "accounts.html", accounts: accounts, navigation: "accounts", topbar: "settings"
  end
end
