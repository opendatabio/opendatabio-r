context("odb_config")

test_that("odb_config with defaults", { 
    cfg = odb_config();
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "http://opendatabio.ib.usp.br/opendatabio/api/v0")
    expect_is(cfg$headers, "request")
    expect_match(cfg$headers$headers["Accept"], "application/json")
    expect_match(cfg$headers$options$useragent, "opendatabio")
})

test_that("odb_config with parameters", { 
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
    cfg = odb_config(api_version = NULL);
    expect_is(cfg, "list")
    expect_is(cfg$base_url, "character")
    expect_equal(cfg$base_url, "http://opendatabio.ib.usp.br/opendatabio/api") 
})
