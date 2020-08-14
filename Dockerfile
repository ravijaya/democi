FROM scratch
ADD sources/dist/add2vals /
CMD ["/add2vals", "4", "5"]
