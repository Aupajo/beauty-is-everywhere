class EpisodeDecorator < SimpleDelegator
  EMOJI = { cabin: "🏡", tree: "🌲" }
  MOUNTAIN_LINES = Rails.root.join('config', 'mountain.html').read.split("\n")

  def series_name
    helpers.content_tag(:small, series.name) if series
  end

  def render_mountain(html_class: 'canvas', style: 'font: 8px/4px monospace')
    return unless snowy_mountains&.nonzero?
    helpers.content_tag(:div, fractional_mountain_lines, class: html_class, style: style)
  end

  def render_critters
    return unless critters
    helpers.safe_join(critter_images)
  end

  def render_forest(html_class: 'forest')
    return unless happy_little_trees&.nonzero?
    content = helpers.safe_join(forest_items)
    helpers.content_tag(:div, content, class: html_class)
  end

  private

  def forest_items
    1.upto(happy_little_trees).flat_map { |n| forest_items_at(n) }
  end

  def forest_items_at(n)
    items = EMOJI[:tree]
    items << EMOJI[:cabin] if cabin? && n == happy_little_trees / 3
    items
  end

  def critter_images
    critters.times.map.with_index { |c, i| critter_image(c, index: i) }
  end

  def critter_image(critter, index:)
    helpers.image_tag("squirrel.jpg",
      class: 'critter-background',
      width: 100,
      style: "
        position: fixed;
        top:  #{150 * index}px;
        left: -100px;
      "
    )
  end

  def snowy_mountains_fraction
    snowy_mountains / 100.0
  end

  def fractional_mountain_lines
    last_line = MOUNTAIN_LINES.size*(snowy_mountains_fraction)
    MOUNTAIN_LINES[0..last_line].join("\n").html_safe
  end

  def helpers
    ActionController::Base.helpers
  end
end
