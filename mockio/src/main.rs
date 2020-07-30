use clap::{crate_version, App, Arg};

fn main() {
    pretty_env_logger::init();

    let app = App::new("mockio")
        .version(crate_version!())
        .arg(Arg::with_name("host").takes_value(true));
    let matches = app.get_matches();
    matches.
}
