context("odb_send_get")

test_that("odb_send_get with defaults", { 
    cfg = odb_config("http://httpbin.org", , NULL, c(Accept="text/html"));
    ret = odb_send_get(list(), cfg, "")
    expect_is(ret, "response")
    expect_equal(http_type(ret), "text/html")
    expect_equal(status_code(ret), 200)
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
    tx = odb_get_taxons(list(limit=10))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("odb_get_taxons works with trailing slashes", { 
    tx = odb_get_taxons(list(limit=10), odb_config("http://opendatabio.ib.usp.br/opendatabio/api/"))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("odb_get_locations works with defaults", { 
    tx = odb_get_locations(list(limit=10))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})

test_that("odb_get_people works with defaults", { 
    tx = odb_get_people(list(limit=10))
    expect_is(tx, "data.frame")
    expect_equal(nrow(tx), 10)
})
