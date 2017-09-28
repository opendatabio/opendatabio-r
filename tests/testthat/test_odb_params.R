test_that("odb_params function works", { 
    expect_equal( odb_params(), "")
    expect_equal( odb_params("string"), "string")
    expect_equal(odb_params(c(taxons=210)), "taxons=210")
    expect_equal(odb_params(c(taxons=210, project=T)), "taxons=210&project=1")
    expect_equal(odb_params(list(taxons=210, project=T)), "taxons=210&project=1")
    expect_equal(odb_params(list(search="edulis", project=T)), "search=edulis&project=1")
})

