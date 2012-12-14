#region Source file version
// $Archive: /SSIS.root/SSIS/ForEachDirectory/ForEachDirectoryUI.cs $
// $Date: 12/18/06 15:49 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: ForEachDirectoryUI.cs $
// $Modtime: 10/11/06 8:49 $
#endregion
        
using System;
using System.Windows.Forms;
using System.Windows.Forms.ComponentModel;
using System.Drawing;
using Microsoft.SqlServer.Dts.Runtime;
using Microsoft.SqlServer.Dts.Runtime.Design;

namespace Dreamdb.Dts
{
  public class ForEachDirectoryUI : ForEachEnumeratorUI
  {
    #region Members
    private Connections cons;
    private Variables vars;
    private ForEachDirectory fed;
    private System.Windows.Forms.CheckBox chkIncludeRoot;
    private System.Windows.Forms.CheckBox chkSiblingsBeforeSubFolders;
    private System.Windows.Forms.ComboBox cboRootDirSource;
    private System.Windows.Forms.ComboBox cboRootDirectory;
    private System.Windows.Forms.CheckBox chkEnumerateSubFolders;
    private System.Windows.Forms.Label lblRootDirectorySource;
    private System.Windows.Forms.Label lblRootDirectory;

    private System.ComponentModel.Container components = null;

    #endregion

    #region Ctor / InitializeComponent / Dispose
    public ForEachDirectoryUI()
      : base()
    {
      InitializeComponent();
    }
    protected override void Dispose(bool disposing)
    {
      if (disposing)
      {
        if (components != null)
        {
          components.Dispose();
        }
      }
      base.Dispose(disposing);
    }
    #region InitializeComponent
    private void InitializeComponent()
    {
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ForEachDirectoryUI));
      this.cboRootDirSource = new System.Windows.Forms.ComboBox();
      this.lblRootDirectorySource = new System.Windows.Forms.Label();
      this.cboRootDirectory = new System.Windows.Forms.ComboBox();
      this.lblRootDirectory = new System.Windows.Forms.Label();
      this.chkIncludeRoot = new System.Windows.Forms.CheckBox();
      this.chkSiblingsBeforeSubFolders = new System.Windows.Forms.CheckBox();
      this.chkEnumerateSubFolders = new System.Windows.Forms.CheckBox();
      this.SuspendLayout();
      // 
      // cboRootDirSource
      // 
      this.cboRootDirSource.DisplayMember = "0";
      this.cboRootDirSource.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
      this.cboRootDirSource.FormattingEnabled = true;
      this.cboRootDirSource.Items.AddRange(new object[] {
            resources.GetString("cboRootDirSource.Items"),
            resources.GetString("cboRootDirSource.Items1"),
            resources.GetString("cboRootDirSource.Items2")});
      resources.ApplyResources(this.cboRootDirSource, "cboRootDirSource");
      this.cboRootDirSource.Name = "cboRootDirSource";
      this.cboRootDirSource.SelectedIndexChanged += new System.EventHandler(this.cboRootDirSource_SelectedIndexChanged);
      // 
      // lblRootDirectorySource
      // 
      resources.ApplyResources(this.lblRootDirectorySource, "lblRootDirectorySource");
      this.lblRootDirectorySource.Name = "lblRootDirectorySource";
      // 
      // cboRootDirectory
      // 
      this.cboRootDirectory.FormattingEnabled = true;
      resources.ApplyResources(this.cboRootDirectory, "cboRootDirectory");
      this.cboRootDirectory.Name = "cboRootDirectory";
      // 
      // lblRootDirectory
      // 
      resources.ApplyResources(this.lblRootDirectory, "lblRootDirectory");
      this.lblRootDirectory.Name = "lblRootDirectory";
      // 
      // chkIncludeRoot
      // 
      resources.ApplyResources(this.chkIncludeRoot, "chkIncludeRoot");
      this.chkIncludeRoot.Name = "chkIncludeRoot";
      // 
      // chkSiblingsBeforeSubFolders
      // 
      resources.ApplyResources(this.chkSiblingsBeforeSubFolders, "chkSiblingsBeforeSubFolders");
      this.chkSiblingsBeforeSubFolders.Name = "chkSiblingsBeforeSubFolders";
      // 
      // chkEnumerateSubFolders
      // 
      resources.ApplyResources(this.chkEnumerateSubFolders, "chkEnumerateSubFolders");
      this.chkEnumerateSubFolders.Name = "chkEnumerateSubFolders";
      this.chkEnumerateSubFolders.CheckedChanged += new System.EventHandler(this.chkEnumerateSubFolders_CheckedChanged);
      // 
      // ForEachDirectoryUI
      // 
      this.Controls.Add(this.chkEnumerateSubFolders);
      this.Controls.Add(this.chkSiblingsBeforeSubFolders);
      this.Controls.Add(this.chkIncludeRoot);
      this.Controls.Add(this.lblRootDirectory);
      this.Controls.Add(this.cboRootDirectory);
      this.Controls.Add(this.lblRootDirectorySource);
      this.Controls.Add(this.cboRootDirSource);
      this.Name = "ForEachDirectoryUI";
      resources.ApplyResources(this, "$this");
      this.ResumeLayout(false);

    }
    #endregion

    #endregion

    #region Initialize
    /// <summary>
    /// This method is called when the ForEachLoop user interface is displayed. During this method the windows form controls 
    /// in this class representing the properties of the ForEachDirectory enumerator are initialized 
    /// from the property values of the enumerator. 
    /// enumerator.
    /// </summary>
    /// <param name="FEEHost">The Host object containing the ForEachDirectory enumerator in the InnerObject property.
    /// <param name="connections">The collection of ConnectionManager objects in the package.</param>
    /// <param name="variables">The collection of Variable objects in the package.</param>
    public override void Initialize(ForEachEnumeratorHost FEEHost, IServiceProvider serviceProvider, Connections connections, Variables variables)
    {
      if (connections == null)
      {
        throw new ArgumentNullException("connections");
      }

      if (FEEHost == null)
      {
        throw new ArgumentNullException("FEEHost");
      }

      if (variables == null)
      {
        throw new ArgumentNullException("variables");
      }

      this.cons = connections;
      this.vars = variables;

      this.fed = FEEHost.InnerObject as ForEachDirectory;

      if (this.fed != null)
      {
        this.chkIncludeRoot.Checked = this.fed.IncludeRootDirectory;
        this.chkEnumerateSubFolders.Checked = this.fed.EnumerateSubFolders;
        this.chkSiblingsBeforeSubFolders.Checked = this.fed.SiblingFoldersBeforeSubFolders;
        this.chkSiblingsBeforeSubFolders.Enabled = this.chkEnumerateSubFolders.Checked;

        if (this.fed.RootDirectorySourceValue == ForEachDirectory.RootDirectorySource.DirectInput)
        {
          this.cboRootDirSource.SelectedIndex = this.cboRootDirSource.Items.IndexOf("DirectInput");
          this.cboRootDirectory.Text = this.fed.RootDirectory;
        }
        else if (this.fed.RootDirectorySourceValue == ForEachDirectory.RootDirectorySource.Variable)
        {
          this.cboRootDirSource.SelectedIndex = this.cboRootDirSource.Items.IndexOf("Variable");

          foreach (Variable v in this.vars)
            cboRootDirectory.Items.Add(v.Name);

          this.cboRootDirectory.SelectedIndex = this.cboRootDirectory.Items.IndexOf(this.fed.RootDirectory);
        }
        else
        {
          this.cboRootDirSource.SelectedIndex = this.cboRootDirSource.Items.IndexOf("ConnectionManager");

          foreach (ConnectionManager cm in this.cons)
            cboRootDirectory.Items.Add(cm.Name);

          this.cboRootDirectory.SelectedIndex = this.cboRootDirectory.Items.IndexOf(this.fed.RootDirectory);
        }
      }
    }
    #endregion

    #region SaveSettings
    /// <summary>
    /// This method is called if the user clicks OK on the ForEachLoop container's editor. The values of the
    /// ForEachDirectory enumerator are updated based on the values contained in the controls in the UserControl.
    /// </summary>
    public override void SaveSettings()
    {
      this.fed.IncludeRootDirectory = this.chkIncludeRoot.Checked;
      this.fed.SiblingFoldersBeforeSubFolders = this.chkSiblingsBeforeSubFolders.Checked;
      this.fed.EnumerateSubFolders = this.chkEnumerateSubFolders.Checked;

      if (this.cboRootDirSource.SelectedItem.ToString() == "DirectInput")
      {
        this.fed.RootDirectorySourceValue = ForEachDirectory.RootDirectorySource.DirectInput;
        this.fed.RootDirectory = this.cboRootDirectory.Text;
      }
      else if (this.cboRootDirSource.SelectedItem.ToString() == "ConnectionManager")
      {
        this.fed.RootDirectorySourceValue = ForEachDirectory.RootDirectorySource.ConnectionManager;
        this.fed.RootDirectory = this.cboRootDirectory.Text;
      }
      else
      {
        this.fed.RootDirectorySourceValue = ForEachDirectory.RootDirectorySource.Variable;
        this.fed.RootDirectory = this.cboRootDirectory.Text;
      }
    }
    #endregion

    #region Control Events
    private void cboRootDirSource_SelectedIndexChanged(object sender, System.EventArgs e)
    {
      this.cboRootDirectory.Items.Clear();

      ForEachDirectory.RootDirectorySource rootDir = new ForEachDirectory.RootDirectorySource();

      this.cboRootDirectory.DropDownStyle = ComboBoxStyle.DropDownList;

      if (this.cboRootDirSource.SelectedItem.ToString() == "DirectInput")
      {
        this.cboRootDirectory.DropDownStyle = ComboBoxStyle.DropDown;
        rootDir = ForEachDirectory.RootDirectorySource.DirectInput;
      }
      else if (this.cboRootDirSource.SelectedItem.ToString() == "ConnectionManager")
      {
        rootDir = ForEachDirectory.RootDirectorySource.ConnectionManager;
      }
      else
      {
        rootDir = ForEachDirectory.RootDirectorySource.Variable;
      }

      SelectRootDirSource(rootDir);
    }

    private void SelectRootDirSource(ForEachDirectory.RootDirectorySource rootDirSource)
    {
      /// Start fresh
      cboRootDirectory.Items.Clear();

      if (rootDirSource == ForEachDirectory.RootDirectorySource.DirectInput)
      {
        // Do nothing
      }
      else if (rootDirSource == ForEachDirectory.RootDirectorySource.Variable)
      {
        foreach (Variable v in this.vars)
        {
          cboRootDirectory.Items.Add(v.Name);
        }
      }
      else
      {
        foreach (ConnectionManager cm in this.cons)
        {
          cboRootDirectory.Items.Add(cm.Name);
        }
      }
    }

    private void chkEnumerateSubFolders_CheckedChanged(object sender, System.EventArgs e)
    {
      this.chkSiblingsBeforeSubFolders.Enabled = this.chkEnumerateSubFolders.Checked;
    }
    #endregion
  }
}
