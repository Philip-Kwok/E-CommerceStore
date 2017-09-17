<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SearchBox.ascx.cs" Inherits="SearchBox" %>
<table border="0" cellpadding="0" cellspacing="0" style="width: 216px">
  <tr>
    <td class="SearchBoxHead">
      Search the Catalog
    </td>
  </tr>
  <tr>
    <td class="SearchBoxContent">
        <asp:Label ID="Label5" runat="server" Text="Search with matching names:"></asp:Label>
        <br />
      <asp:TextBox ID="searchTextBox" Runat="server" Width="128px" CssClass="SearchBox" BorderStyle="Dotted" MaxLength="100" Height="16px" />
        <br />
      <asp:CheckBox ID="allWordsCheckBox" CssClass="SearchBox" Runat="server" Text="Search for all words" Visible="False" />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Select Price Range:"></asp:Label>
        <br />
        <asp:Label ID="Label3" runat="server" Text="Between :"></asp:Label>
        <asp:DropDownList ID="DropDownList1" runat="server">
            <asp:ListItem>30</asp:ListItem>
            <asp:ListItem>50</asp:ListItem>
            <asp:ListItem>70</asp:ListItem>
            <asp:ListItem>90</asp:ListItem>
            <asp:ListItem></asp:ListItem>
        </asp:DropDownList>
&nbsp;<asp:Label ID="Label4" runat="server" Text="and"></asp:Label>
&nbsp;<asp:DropDownList ID="DropDownList2" runat="server">
            <asp:ListItem>100</asp:ListItem>
            <asp:ListItem>150</asp:ListItem>
            <asp:ListItem Value="250"></asp:ListItem>
        </asp:DropDownList>
&nbsp;<br />
        <br />
        <asp:Label ID="Label2" runat="server" Text="Category:"></asp:Label>
        <br />
        <asp:DropDownList ID="DropDownList3" runat="server">
            <asp:ListItem Value="1">Men&#39;s</asp:ListItem>
            <asp:ListItem Value="1">Women&#39;s</asp:ListItem>
        </asp:DropDownList>
        <br />
        <br />
      <asp:Button ID="goButton" Runat="server" CssClass="SearchBox" Text="Go!" Width="36px" Height="21px" OnClick="goButton_Click" />
        <br />
        <br />
        <br />
        <br />
    </td>
  </tr>
</table>
<asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="ProductID" DataSourceID="SqlDataSource1" EmptyDataText="There are no data records to display." ForeColor="#333333" GridLines="None" OnLoad="goButton_Click" CssClass="searchResult">
    <AlternatingRowStyle BackColor="White" />
    <Columns>
        <asp:BoundField DataField="ProductID" HeaderText="ProductID" InsertVisible="False" ReadOnly="True" SortExpression="ProductID" />
        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
        <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" />
        <asp:TemplateField HeaderText="Thumbnail" SortExpression="Thumbnail">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Thumbnail") %>'></asp:TextBox>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Image ID="Image1" runat="server" ImageUrl='<%# "/ProductImages/" + Eval("Thumbnail") %>' Height="70" Width="70"/>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# "/Product.aspx?ProductID=" + Eval("ProductID") %>' Text='<%# Eval("ProductID") %>'></asp:HyperLink>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EditRowStyle BackColor="#2461BF" />
    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
    <RowStyle BackColor="#EFF3FB" />
    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
    <SortedAscendingCellStyle BackColor="#F5F7FB" />
    <SortedAscendingHeaderStyle BackColor="#6D95E1" />
    <SortedDescendingCellStyle BackColor="#E9EBEF" />
    <SortedDescendingHeaderStyle BackColor="#4870BE" />
</asp:GridView>
<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:BalloonShopConnection %>" DeleteCommand="DELETE FROM [Product] WHERE [ProductID] = @ProductID" InsertCommand="INSERT INTO [Product] ([Name], [Price], [Thumbnail]) VALUES (@Name, @Price, @Thumbnail)" SelectCommand="SELECT Product.ProductID, [Name], [Price], [Thumbnail] FROM Product INNER JOIN ProductCategory ON Product.ProductID = ProductCategory.ProductID  WHERE Name LIKE '%' + @Name + '%'  AND Price BETWEEN @p1 AND @p2 AND CategoryID = @categoryID" UpdateCommand="UPDATE [Product] SET [Name] = @Name, [Price] = @Price, [Thumbnail] = @Thumbnail WHERE [ProductID] = @ProductID">
    <DeleteParameters>
        <asp:Parameter Name="ProductID" Type="Int32" />
    </DeleteParameters>
    <InsertParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="Price" Type="Decimal" />
        <asp:Parameter Name="Thumbnail" Type="String" />
    </InsertParameters>
    <SelectParameters>
        <asp:ControlParameter ControlID="searchTextBox" Name="Name" PropertyName="Text" Type="String" DefaultValue="" />
        <asp:ControlParameter ControlID="DropDownList1" Name="p1" PropertyName="SelectedValue" />
        <asp:ControlParameter ControlID="DropDownList2" Name="p2" PropertyName="SelectedValue" />
        <asp:ControlParameter ControlID="DropDownList3" Name="categoryID" PropertyName="SelectedValue" />
    </SelectParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="Price" Type="Decimal" />
        <asp:Parameter Name="Thumbnail" Type="String" />
        <asp:Parameter Name="ProductID" Type="Int32" />
    </UpdateParameters>
</asp:SqlDataSource>

