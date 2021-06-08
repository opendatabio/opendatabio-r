context("odb_send_get")

test_that("odb_send_get with defaults", { 
    cfg = odb_config("http://httpbin.org", , NULL, c(Accept="text/html"));
    ret = odb_send_get(list(), cfg, "")
    expect_is(ret, "response")
    expect_equal(http_type(ret), "text/html")
    expect_equal(status_code(ret), 200)
})

test_that("errors display a helpful message", {
    cfg = odb_config("http://httpbin.org", , NULL, c(Accept="text/html"));
    expect_error(
        odb_send_get(list(), cfg, "status/404"),
        "Check a full list of error codes")
})

test_that("odb_send_get checks http_type", { 
    cfg = odb_config("http://httpbin.org", , NULL, c(Accept="application/json; text/html; */*"));
    ret = odb_send_get(list(), cfg, "headers")
    expect_is(ret, "response")
    expect_equal(http_type(ret), "application/json")
    cfg = odb_config("http://httpbin.org", , NULL, c(Accept="blablabla"));
    expect_error(odb_send_get(list(), cfg, "headers"), "Wrong answer type from server")
})

test_that("odb_get_taxons works with defaults", { 
    internal_clear_env();
    tx = odb_get_taxons(list(limit=10))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("odb_get_taxons works with trailing slashes", { 
    internal_clear_env();
    tx = odb_get_taxons(list(limit=10), odb_config("http://localhost/opendatabio/api/"))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("odb_get_locations works with defaults", { 
    internal_clear_env();
    tx = odb_get_locations(list(limit=10))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("odb_get_persons works with defaults", { 
    internal_clear_env();
    tx = odb_get_persons(list(limit=10))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("simplify argument works", {
    internal_clear_env();
    not.simp = odb_get_taxons(list(limit=10), simplify = FALSE)
    expect_equal(class(not.simp$fullname), "list")
    simp = odb_get_taxons(list(limit=10), simplify = TRUE)
    expect_equal(class(simp$fullname), "character")
})

