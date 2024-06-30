defmodule GameApp.Workers.IncrementWorker do
  @moduledoc """
  This module provides functions to increment an integer synchronously and asynchronously.
  """
  @doc """
  Increases the given integer by one.

  ## Parameters
  - `integer`: an integer value to be incremented.

  ## Returns
  Returns the incremented integer.

  ## Example
      iex> GameApp.Workers.IncrementWorker.sync(5)
      6
  """
  @spec sync(integer :: integer) :: integer
  def sync(integer) when is_integer(integer) do
    integer + 1
  end

  @doc """
  Asynchronously increments the given integer by one after a delay.

  This function starts a new asynchronous task that will wait for 3 seconds
  before calling the `sync` function to increment the provided integer.

  ## Parameters
  - `integer`: an integer value to be incremented asynchronously.

  ## Returns
  Returns a `Task` struct representing the asynchronous operation.

  ## Example
      iex> task = GameApp.Workers.IncrementWorker.async(5)
      #Task<...>
      iex> Task.await(task)
      6
  """
  @spec async(integer :: integer) :: Task.t()
  def async(integer) when is_integer(integer) do
    Task.async(fn ->
      Process.sleep(3_000)
      sync(integer)
    end)
  end
end
