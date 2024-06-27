defmodule GameAppWeb.GetTextLive.Index do
  use GameAppWeb, :live_view

  alias GameApp.External.TextExtractService
  alias GameApp.Websites.GetText
  @impl true
  def mount(_session, _params, socket) do
    changeset = GetText.create_changeset(%{})

    socket =
      socket
      |> assign(:result, "")
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"get_text" => params}, socket) do
    changeset =
      GetText.create_changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("submit", %{"get_text" => params}, socket) do
    changeset = GetText.create_changeset(params)

    if changeset.valid? do
      url = changeset.changes[:url]

      case TextExtractService.extract_text(url) do
        {:ok, text} ->
          socket =
            socket
            |> assign(:result, text)

          {:noreply, socket}

        {:error, reason} ->
          socket =
            socket
            |> assign(:result, "")
            |> put_flash(:error, "Failed to extract text: #{reason}")

          {:noreply, socket}
      end
    else
      socket =
        socket
        |> assign(:result, "")
        |> assign_form(changeset |> Map.put(:action, :validate))
        |> put_flash(:error, "Validation error, please check the input.")

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("clear_result", _params, socket) do
    {:noreply, assign(socket, :result, "")}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
