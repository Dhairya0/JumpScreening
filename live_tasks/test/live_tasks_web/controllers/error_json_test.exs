defmodule LiveTasksWeb.ErrorJSONTest do
  use LiveTasksWeb.ConnCase, async: true

  test "renders 404" do
    assert LiveTasksWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert LiveTasksWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
