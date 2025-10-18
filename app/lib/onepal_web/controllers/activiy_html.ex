defmodule OnepalWeb.ActiviyHTML do
  use OnepalWeb, :html

  embed_templates "activiy_html/*"

  @doc """
  Renders a activiy form.

  The form is defined in the template at
  activiy_html/activiy_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def activiy_form(assigns)
end
