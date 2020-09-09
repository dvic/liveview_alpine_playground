defmodule DemoWeb.PageLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :add, 1000)
    end

    {:ok, assign(socket, items: [])}
  end

  @impl true
  def handle_info(:add, socket) do
    {:noreply, socket |> assign(items: [DateTime.utc_now() | socket.assigns.items])}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div x-data>
        <ul>
          <li id="fixed_item" @click="item_clicked($event)">
            <div><span>the fixed item</span></div>
          </li>
          <%= for {_, idx} <- @items |> Enum.with_index() do %>
          <li id="item_<%= idx %>" @click="item_clicked($event)">
            <div><span>alpinejs on click li (this one calls the handler twice)</span></div>
          </li>
          <li x-data id="item_<%= idx %>_scope" @click="item_clicked($event)">
            <div><span>alpinejs on click li with x-data on li</span></div>
          </li>
          <li id="item_<%= idx %>_native" onClick="item_clicked(event)">
            <div><span>native on click li</span></div>
          </li>
          <% end %>
        </ul>
      </div>
    """
  end
end
