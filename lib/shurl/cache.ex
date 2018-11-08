defmodule Shurl.Cache do
  def read(key) do
    ConCache.get(name(), key)
  end

  def write(key, value) do
    ConCache.put(name(), key, %ConCache.Item{value: value})
  end

  def name() do
    Application.get_env(:shurl, :cache)
  end
end
