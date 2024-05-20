import sketch as s
import sketch/lustre/extra as l
import sketch/size.{px, vh}

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
  l.element("div", attributes, children, [
    s.color(palette.black),
    s.font_family(
      "-apple-system, BlinkMacSystemFont, avenir next, avenir, segoe ui, helvetica neue, helvetica, Cantarell, Ubuntu, roboto, noto, arial, sans-serif",
    ),
    s.min_height(vh(100)),
    s.margin(px(-10)),
    s.background(palette.aged_plastic_yellow),
    s.display("flex"),
    s.flex_direction("column"),
    s.justify_content("center"),
  ])
}

pub fn main(attributes, children) {
  l.element("main", attributes, children, [
    s.padding(px(24)),
    s.max_width(px(700)),
    s.margin_("0 auto"),
    s.display("flex"),
    s.flex_direction("column"),
    s.gap(px(48)),
  ])
}

pub fn lucy(attributes) {
  l.element("img", attributes, [], [s.width(px(60))])
}

pub fn header_wrapper(attributes, children) {
  l.element("div", attributes, children, [
    s.display("flex"),
    s.gap(px(12)),
    s.align_items("center"),
  ])
}

pub fn title_wrapper(attributes, children) {
  l.element("div", attributes, children, [
    s.display("flex"),
    s.flex_direction("column"),
    s.gap(px(6)),
  ])
}

pub fn title(attributes, children) {
  l.element("div", attributes, children, [
    s.font_weight("600"),
    s.font_size(px(24)),
  ])
}

pub fn subtitle(attributes, children) {
  l.element("div", attributes, children, [
    s.font_weight("500"),
    s.color(palette.underwater_blue),
  ])
}

pub fn actions_wrapper(attributes, children) {
  l.element("div", attributes, children, [s.display("flex"), s.gap(px(12))])
}

pub fn toast_button(background, color, attributes, children) {
  let id = "button-" <> background
  l.dynamic("button", attributes, children, id, [
    s.font_family("inherit"),
    s.cursor("pointer"),
    s.appearance("none"),
    s.background(background),
    s.border("none"),
    s.color(color),
    s.font_size(px(20)),
    s.padding_("12px 24px"),
    s.border_radius(px(10)),
    s.font_weight("600"),
    s.box_shadow("2px 2px 2px 1px #bbb"),
    s.transition(".3s box-shadow"),
    s.active([s.box_shadow("inset 2px 2px 5px 1px #aaa")]),
  ])
}

pub fn section(attributes, children) {
  l.element("section", attributes, children, [
    s.display("flex"),
    s.flex_direction("column"),
    s.gap(px(12)),
  ])
}

pub fn section_description(attributes, children) {
  l.element("div", attributes, children, [])
}
