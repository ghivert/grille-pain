import sketch/css
import sketch/css/length.{px, vh}
import sketch/lustre/element/html

pub type Palette {
  Palette(
    white: String,
    dark_white: String,
    unnamed_blue: String,
    faff_pink: String,
    dark_faff_pink: String,
    aged_plastic_yellow: String,
    unexpected_aubergine: String,
    underwater_blue: String,
    charcoal: String,
    black: String,
    blacker: String,
  )
}

pub const palette = Palette(
  white: "#fefefc",
  dark_white: "#aeaeac",
  unnamed_blue: "#a6f0fc",
  faff_pink: "#ffaff3",
  dark_faff_pink: "#eb94de",
  aged_plastic_yellow: "#fffbe8",
  unexpected_aubergine: "#584355",
  underwater_blue: "#292d3e",
  charcoal: "#2f2f2f",
  black: "#1e1e1e",
  blacker: "#151515",
)

pub fn body(attributes, children) {
  let font_family =
    "-apple-system, BlinkMacSystemFont, avenir next, avenir, segoe ui, helvetica neue, helvetica, Cantarell, Ubuntu, roboto, noto, arial, sans-serif"
  css.class([
    css.color(palette.black),
    css.font_family(font_family),
    css.min_height(vh(100)),
    css.margin(px(-10)),
    css.background(palette.aged_plastic_yellow),
    css.display("flex"),
    css.flex_direction("column"),
    css.justify_content("center"),
  ])
  |> html.div(attributes, children)
}

pub fn main(attributes, children) {
  css.class([
    css.padding(px(24)),
    css.max_width(px(700)),
    css.margin_("0 auto"),
    css.display("flex"),
    css.flex_direction("column"),
    css.gap(px(48)),
  ])
  |> html.main(attributes, children)
}

pub fn lucy(attributes) {
  html.img(css.class([css.width(px(60))]), attributes)
}

pub fn header_wrapper(attributes, children) {
  css.class([css.display("flex"), css.gap(px(12)), css.align_items("center")])
  |> html.div(attributes, children)
}

pub fn title_wrapper(attributes, children) {
  css.class([css.display("flex"), css.flex_direction("column"), css.gap(px(6))])
  |> html.div(attributes, children)
}

pub fn title(attributes, children) {
  css.class([css.font_weight("600"), css.font_size(px(24))])
  |> html.div(attributes, children)
}

pub fn subtitle(attributes, children) {
  css.class([css.font_weight("500"), css.color(palette.underwater_blue)])
  |> html.div(attributes, children)
}

pub fn actions_wrapper(attributes, children) {
  css.class([css.display("flex"), css.gap(px(12))])
  |> html.div(attributes, children)
}

pub fn toast_button(background, color, attributes, children) {
  css.class([
    css.font_family("inherit"),
    css.cursor("pointer"),
    css.appearance("none"),
    css.background(background),
    css.border("none"),
    css.color(color),
    css.font_size(px(20)),
    css.padding_("12px 24px"),
    css.border_radius(px(10)),
    css.font_weight("600"),
    css.box_shadow("2px 2px 2px 1px #bbb"),
    css.transition(".3s box-shadow"),
    css.active([css.box_shadow("inset 2px 2px 5px 1px #aaa")]),
  ])
  |> html.button(attributes, children)
}

pub fn section(attributes, children) {
  css.class([css.display("flex"), css.flex_direction("column"), css.gap(px(12))])
  |> html.section(attributes, children)
}

pub fn section_title(attributes, children) {
  css.class([css.font_size(length.rem(1.05)), css.font_weight("600")])
  |> html.h2(attributes, children)
}

pub fn section_description(attributes, children) {
  html.div_(attributes, children)
}
