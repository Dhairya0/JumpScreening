defmodule LiveTasksWeb.TaskLive do
  use LiveTasksWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, tasks: [], input: "", due_date: "", sort: "due_date")}
  end

  def handle_event("update_input", %{"task" => %{"input" => val}}, socket) do
    {:noreply, assign(socket, input: val)}
  end

  def handle_event("update_due", %{"task" => %{"due_date" => val}}, socket) do
    {:noreply, assign(socket, due_date: val)}
  end

  def handle_event("add_task", %{"task" => %{"input" => input, "due_date" => due}}, socket) do
    if String.trim(input) == "" do
      {:noreply, put_flash(socket, :error, "Task name cannot be blank")}
    else
      new_task = %{
        id: System.unique_integer(),
        name: input,
        due_date: due,
        completed: false
      }

      updated = sort_tasks([new_task | socket.assigns.tasks], socket.assigns.sort)
      {:noreply, assign(socket, tasks: updated, input: "", due_date: "")}
    end
  end

  def handle_event("delete_task", %{"id" => id}, socket) do
    id = String.to_integer(id)
    updated = Enum.reject(socket.assigns.tasks, &(&1.id == id))
    {:noreply, assign(socket, tasks: sort_tasks(updated, socket.assigns.sort))}
  end

  def handle_event("toggle_complete", %{"id" => id}, socket) do
    id = String.to_integer(id)

    updated = Enum.map(socket.assigns.tasks, fn
      %{id: ^id} = task -> %{task | completed: !task.completed}
      task -> task
    end)

    {:noreply, assign(socket, tasks: sort_tasks(updated, socket.assigns.sort))}
  end

  def handle_event("sort", %{"sort" => sort_by}, socket) do
    {:noreply, assign(socket, sort: sort_by, tasks: sort_tasks(socket.assigns.tasks, sort_by))}
  end

  def handle_event("export", _, socket) do
    csv = [["Task", "Due Date", "Completed"] |
           Enum.map(socket.assigns.tasks, fn t ->
             [t.name, t.due_date, if(t.completed, do: "Yes", else: "No")]
           end)]
    |> CSV.encode()
    |> Enum.join()

    {:noreply,
      socket
      |> put_flash(:info, "CSV download started")
      |> push_event("download", %{content: csv, filename: "tasks.csv"})}
  end

  defp sort_tasks(tasks, "due_date") do
    Enum.sort_by(tasks, &(&1.due_date))
  end

  defp sort_tasks(tasks, "completed") do
    Enum.sort_by(tasks, &(&1.completed))
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-2xl mx-auto">
      <h1 class="text-3xl font-bold mb-4">📝 Live To-Do List</h1>

      <form phx-submit="add_task">
        <div class="flex gap-2 mb-4">
          <input name="task[input]" value={@input} phx-change="update_input"
            placeholder="Task name..." class="border rounded px-3 py-2 w-full"/>
          <input type="date" name="task[due_date]" value={@due_date} phx-change="update_due"
            class="border rounded px-3 py-2"/>
          <button class="bg-blue-600 text-white px-4 py-2 rounded">Add</button>
        </div>
      </form>

      <div class="flex justify-between items-center mb-3">
        <div>
          <button phx-click="sort" phx-value-sort="due_date" class="text-sm underline mr-3 text-blue-700">Sort by Due Date</button>
          <button phx-click="sort" phx-value-sort="completed" class="text-sm underline text-blue-700">Sort by Completed</button>
        </div>
        <button phx-click="export" class="bg-green-600 text-white px-3 py-1 rounded">Export CSV</button>
      </div>

      <%= if Enum.empty?(@tasks) do %>
        <p class="italic text-gray-400 mt-4">No tasks yet. Add your first one above!</p>
      <% else %>
        <ul>
          <%= for task <- @tasks do %>
            <li class="mb-2 flex justify-between items-center border-b pb-1">
              <div>
                <span class={if task.completed, do: "line-through text-gray-500", else: ""}>
                  <%= task.name %> — <%= task.due_date %>
                </span>
              </div>
              <div>
                <button phx-click="toggle_complete" phx-value-id={task.id}
                        class="text-yellow-600 text-sm mr-3">
                  <%= if task.completed, do: "Undo", else: "Complete" %>
                </button>
                <button phx-click="delete_task" phx-value-id={task.id}
                        class="text-red-600 text-sm">Delete</button>
              </div>
            </li>
          <% end %>
        </ul>
      <% end %>

      <.flash kind="info"/>
      <script>
        window.addEventListener("phx:download", e => {
          const a = document.createElement('a');
          a.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(e.detail.content);
          a.download = e.detail.filename;
          a.click();
        });
      </script>
    </div>
    """
  end
end
