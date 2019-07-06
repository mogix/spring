$: << File.expand_path("../../..", $LOADED_FEATURES.grep(%r{/bundler/setup\.rb$}).first)
$: << File.expand_path("../../..", __FILE__)
require "spring/application/boot"
