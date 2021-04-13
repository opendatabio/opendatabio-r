context("odb_config")

test_that("odb_config with defaults", { 
    internal_clear_env();
    cfg = odb_config();
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "http://localhost/opendatabio/api/v0")
    expect_is(cfg$headers, "request")
    expect_match(cfg$headers$headers["Accept"], "application/json")
    expect_match(cfg$headers$options$useragent, "opendatabio")
})

test_that("odb_config with parameters", { 
    internal_clear_env();
    cfg = odb_config("http://localhost", "ABCDEF", "v1", c(foo="bar"));
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "http://localhost/v1")
    expect_is(cfg$headers, "request")
    expect_match(cfg$headers$headers["Accept"], "application/json")
    expect_match(cfg$headers$headers["foo"], "bar")
    expect_match(cfg$headers$headers["Authorization"], "ABCDEF")
})

test_that("odb_config with null version", { 
    internal_clear_env();
    cfg = odb_config(api_version = NULL);
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "http://localhost/opendatabio/api") 
})

test_that("odb_config with ENV variables", {
    Sys.setenv(ODB_TOKEN = "12345", ODB_BASE_URL="www.example.com", ODB_API_VERSION = "vx")
    cfg = odb_config();
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "www.example.com/vx")
    expect_is(cfg$headers, "request")
    expect_match(cfg$headers$headers["Accept"], "application/json")
    expect_match(cfg$headers$headers["Authorization"], "12345")
})

test_that("odb_config with ENV variables respects parameters", {
    Sys.setenv(ODB_TOKEN = "12345", ODB_BASE_URL="www.example.com", ODB_API_VERSION = "vx")
    cfg = odb_config("http://localhost", "ABCDEF", "v1", c(foo="bar"));
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "http://localhost/v1")
    expect_is(cfg$headers, "request")
    expect_match(cfg$headers$headers["Accept"], "application/json")
    expect_match(cfg$headers$headers["foo"], "bar")
    expect_match(cfg$headers$headers["Authorization"], "ABCDEF")
})
