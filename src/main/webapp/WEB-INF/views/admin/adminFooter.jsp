<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#sidebarCollapse').on('click', function () {
                $('#sidebar, #content, .navbar-custom').toggleClass('active');
                $(this).toggleClass('active');
            });
        });

        // For dropdown menus in sidebar
        $('.dropdown-toggle').click(function(e) {
            e.preventDefault();
            $(this).next('.collapse').slideToggle();
            $(this).toggleClass('active');
        });
    </script>
</body>
</html>