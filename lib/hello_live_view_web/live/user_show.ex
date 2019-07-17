defmodule HelloLiveViewWeb.UserShow do
  use HelloLiveViewWeb, :live_view
  alias HelloLiveView.Accounts

  def render(assigns), do: HelloLiveViewWeb.UserView.render("show.html", assigns)

  def mount(%{path_params: %{"id" => user_id}}, socket) do
    if connected?(socket), do: Accounts.subscribe()
    {:ok, assign(socket, :user, Accounts.get_user!(user_id))}
  end

  def handle_info({Accounts, [:user, :updated], %{id: user_id}}, %{assigns: %{user: %{id: user_id}}} = socket) do 
    {:noreply, assign(socket, user: Accounts.get_user!(user_id))}
  end

  def handle_info({Accounts, [:user, :deleted], %{id: user_id}}, %{assigns: %{user: %{id: user_id}}} = socket) do
    socket =
      socket
      |> put_flash(:error, "User was deleted!")
      |> redirect(to: Routes.live_path(socket, HelloLiveViewWeb.UserIndex))
    {:stop, socket}
  end

  def handle_info(_message, socket),
    do: {:noreply, socket}
end