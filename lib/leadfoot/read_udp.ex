defmodule Leadfoot.ReadUdp do
  @moduledoc false

  use GenServer
  alias Leadfoot.ParsePacket
  alias Phoenix.PubSub

  @initial_state %{
    file: nil,
    filename: nil,
    port: 21_337
  }

  def start_link(state \\ %{}, _opts \\ []) do
    GenServer.start_link(__MODULE__, state, name: Leadfoot.ReadUdp)
  end

  def start(filename) do
    GenServer.cast(Leadfoot.ReadUdp, {:start, filename})
  end

  def stop() do
    GenServer.cast(Leadfoot.ReadUdp, :stop)
  end

  def status() do
    GenServer.call(Leadfoot.ReadUdp, :status)
  end

  @impl true
  def init(_opts) do
    {:ok, @initial_state, {:continue, :open_port}}
  end

  @impl true
  def handle_continue(:open_port, state) do
    # todo allow for port selection at run time
    {:ok, _socket} = :gen_udp.open(state.port, mode: :binary)
    {:noreply, state}
  end

  @impl true
  def handle_info({:udp, _socket, _ip, _port, data}, state) do
    event = ParsePacket.parse_packet(data)
    PubSub.broadcast(Leadfoot.PubSub, "session", {:event, event})

    if state.file != nil do
      len = byte_size(data)
      IO.binwrite(state.file, <<len::16>> <> data)
    end

    {:noreply, state}
  end

  @impl true
  def handle_cast({:start, filename}, state) do
    {:ok, file} = File.open(filename, [:write])

    {:noreply, %{state | file: file, filename: filename}}
  end

  @impl true
  def handle_cast(:stop, state) do
    File.close(state.file)
    {:noreply, @initial_state}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, %{port: state.port}, state}
  end
end
