context("odb_params")

test_that("odb_params function works", { 
    expect_equal(odb_params(), "")
    expect_equal(odb_params("string"), "string")
    expect_equal(odb_params(list(taxons=210)), "taxons=210")
    expect_equal(odb_params(list(taxons=210, project=T)), "taxons=210&project=1")
    expect_equal(odb_params(list(search="edulis", project=T)), "search=edulis&project=1")
    # Notice this would by default be encoded
    expect_equal(odb_params(list(id=c(1,2,3), fields=c("a", "b")), encode = FALSE), "id=1,2,3&fields=a,b")
})

test_that("odb_params encodes special characters but leaves = & * , alone in the long form", {
    expect_equal(odb_params("search=Assis Brasil"), "search=Assis%20Brasil")
    expect_equal(odb_params("search=Capão da Canoa"), "search=Cap%C3%A3o%20da%20Canoa")
    expect_equal(odb_params(list(search="Assis Brasil", project=TRUE)), "search=Assis%20Brasil&project=1")
    expect_equal(odb_params(list(search="Assi*", project=TRUE)), "search=Assi%2A&project=1")
    expect_equal(odb_params(list(tag="1=1")), "tag=1%3D1")
    expect_equal(odb_params(list(id=c(1,2,3))), "id=1%2C2%2C3")
    expect_equal(odb_params('%$& !', encode=FALSE), '%$& !')
})

