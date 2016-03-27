# <%- chapter.title %>

<% if (chapter.cover) { %>
<%- chapter.cover.replace(/chapter-\d+/, ".") %>
<% } %>

## 目次

<%- chapter.pages.map(page => `* ${page.link}`).join("\n") %>
