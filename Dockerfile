FROM scratch
RUN cd sources/dist/
ADD add2vals /
CMD ["/add2vals"]
