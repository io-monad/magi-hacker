# <%- chapter.title %>

<% if (chapter.cover) { %>
<%- chapter.cover.replace(/chapter-\d+/, ".") %>
<% } %>

## 目次

<%-
    chapter.pages.map(page => {
        return "* " + page.link.replace(/chapter-\d+\//, "");
    }).join("\n")
%>
