defmodule GameAppWeb.SuperheroControllerTest do
  @moduledoc """
  Tests for the `GameAppWeb.SuperheroController` module.
  """
  use GameAppWeb.ConnCase

  @moduletag :superhero
  @moduletag :controller
  @moduletag :database

  @invalid_attrs %{name: nil, location: nil, power: nil}

  def get_path do
    ~p"/api/superheroes"
  end

  def get_path(id) do
    ~p"/api/superheroes/#{id}"
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_superhero_1]

    test "success: lists all superheroes", %{conn: conn, superhero_1: superhero} do
      conn = get(conn, get_path())
      assert json_response(conn, 200)["data"] == [superhero_to_json(superhero)]
    end
  end

  describe "create superhero" do
    test "success: renders superhero when data is valid", %{conn: conn} do
      create_superhero_attr = get_superhero_attr()
      conn = post(conn, get_path(), superhero: create_superhero_attr)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, get_path(id))
      response_data = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "location" => location,
               "name" => name,
               "power" => power
             } = response_data

      assert location == create_superhero_attr[:location]
      assert name == create_superhero_attr[:name]
      assert power == create_superhero_attr[:power]
    end

    test "failure: renders errors when power is less than 1", %{conn: conn} do
      invalid_power_attr = Map.put(get_superhero_attr(), :power, -1)
      conn = post(conn, get_path(), superhero: invalid_power_attr)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "failure: renders errors when power is greater than 100", %{conn: conn} do
      invalid_power_attr = Map.put(get_superhero_attr(), :power, 101)
      conn = post(conn, get_path(), superhero: invalid_power_attr)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "failure: renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, get_path(), superhero: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update superhero" do
    setup [:create_superhero_1]

    test "success: updates superhero when data is valid", %{conn: conn, superhero_1: superhero} do
      updated_attrs = get_superhero_attr()
      conn = put(conn, ~p"/api/superheroes/#{superhero.id}", superhero: updated_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, get_path(id))
      response_data = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "location" => location,
               "name" => name,
               "power" => power
             } = response_data

      assert location == updated_attrs[:location]
      assert name == updated_attrs[:name]
      assert power == updated_attrs[:power]
    end

    test "failure: renders errors when updating power to -1", %{
      conn: conn,
      superhero_1: superhero
    } do
      invalid_power_attr = Map.put(get_superhero_attr(), :power, -1)
      conn = put(conn, get_path(superhero.id), superhero: invalid_power_attr)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "failure: renders errors when updating power to 101", %{
      conn: conn,
      superhero_1: superhero
    } do
      invalid_power_attr = Map.put(get_superhero_attr(), :power, 101)
      conn = put(conn, get_path(superhero.id), superhero: invalid_power_attr)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "failure: renders errors when data is invalid", %{conn: conn, superhero_1: superhero} do
      conn = put(conn, get_path(superhero.id), superhero: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete superhero" do
    setup [:create_superhero_1]

    test "success: deletes chosen superhero", %{conn: conn, superhero_1: superhero} do
      conn = delete(conn, get_path(superhero.id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, get_path(superhero.id))
      end
    end
  end

  defp get_superhero_attr do
    %{
      name: Faker.Superhero.name(),
      location: Faker.Address.city(),
      power: Faker.random_between(1, 100)
    }
  end

  defp superhero_to_json(superhero) do
    superhero
    |> Map.from_struct()
    |> Map.drop([:__meta__, :inserted_at, :updated_at])
    |> Enum.into(%{}, fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
