<%@ Page Language="C#" MasterPageFile="~/BalloonShop.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" Title="Welcome to BalloonShop!" %>

<%@ Register Src="UserControls/ProductsList.ascx" TagName="ProductsList" TagPrefix="uc1" %>
<asp:Content ID="content" ContentPlaceHolderID="contentPlaceHolder" Runat="server">
  <span class="CatalogTitle">Welcome to ShoeShop! </span>
  <br />
  <span class="CatalogDescription">Check out our coolest collection of top end shoes by selecting your department and category! </span>
  <br />
  <uc1:ProductsList ID="ProductsList1" runat="server" />
</asp:Content>

