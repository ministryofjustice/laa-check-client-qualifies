Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: {
      top: "2cm",
      bottom: "2cm",
      left: "1cm",
      right: "1cm",
    },
    emulate_media: "print",
  }
end
