#region Source file version
// $Archive: /SSIS.root/SSIS/ForEachDirectory/ForEachDirectory.cs $
// $Date: 12/18/06 15:49 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: ForEachDirectory.cs $
// $Modtime: 10/11/06 8:48 $
#endregion

using System;
using System.IO;
using System.Xml;
using System.Collections;
using Microsoft.SqlServer.Dts.Runtime;
using Microsoft.SqlServer.Dts.Runtime.Enumerators;

namespace Dreamdb.Dts
{
  [DtsForEachEnumerator(
    DisplayName = "For Each Directory Enumerator",
    Description = "Enumerates directories, and optionally, subdirectories",
    UITypeName = "Dreamdb.Dts.ForEachDirectoryUI,ForEachDirectory,Version=1.0.0.0,Culture=Neutral,PublicKeyToken=15b382e1c866425b"
  )]
  public class ForEachDirectory : ForEachEnumerator, IDTSComponentPersist
  {
    #region Members
    private ArrayList directories;
    private string rootDirectoryValue;
    private bool enumerateSubFoldersValue;
    private bool includeRootDirectoryValue;
    private bool siblingFoldersBeforeSubFoldersValue;
    private RootDirectorySource rootDirectorySourceValue;

    public enum RootDirectorySource
    {
      DirectInput,
      Variable,
      ConnectionManager
    }
    #endregion

    #region Properties
    public string RootDirectory
    {
      get
      {
        return this.rootDirectoryValue;
      }

      set
      {
        this.rootDirectoryValue = value;
      }
    }

    public bool EnumerateSubFolders
    {
      get
      {
        return this.enumerateSubFoldersValue;
      }

      set
      {
        this.enumerateSubFoldersValue = value;
      }
    }

    public RootDirectorySource RootDirectorySourceValue
    {
      get
      {
        return this.rootDirectorySourceValue;
      }

      set
      {
        this.rootDirectorySourceValue = value;
      }
    }

    public bool IncludeRootDirectory
    {
      get
      {
        return this.includeRootDirectoryValue;
      }

      set
      {
        this.includeRootDirectoryValue = value;
      }
    }

    public bool SiblingFoldersBeforeSubFolders
    {
      get
      {
        return siblingFoldersBeforeSubFoldersValue;
      }

      set
      {
        siblingFoldersBeforeSubFoldersValue = value;
      }
    }

    #endregion

    #region Validate
    /// <summary>
    /// This method is called by the runtime to allow the enumerator to verify that it is properly configured.
    /// The ForEachDirectory enumerator verifies that the RootDirectory value is specified. No other configuration is required.
    /// </summary>
    /// <param name="connections">The collection of ConnectionManagers in the package.</param>
    /// <param name="variableDispenser">A VariableDispenser used to read and write variables in the package.</param>
    /// <param name="infoEvents">Used to fire events.</param>
    /// <param name="log">Used to write log entries.</param>
    /// <returns>A value from the DTSExecResult indicating the success or failure of validation.
    /// If Failure is returned then the package will not execute.</returns>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
    public override DTSExecResult Validate(Connections connections, VariableDispenser variableDispenser, IDTSInfoEvents infoEvents, IDTSLogging log)
    {
      if (connections == null)
      {
        throw new ArgumentNullException("connections");
      }

      if (variableDispenser == null)
      {
        throw new ArgumentNullException("variableDispenser");
      }

      if (infoEvents == null)
      {
        throw new ArgumentNullException("infoEvents");
      }

      try
      {
        if (this.rootDirectorySourceValue == RootDirectorySource.ConnectionManager)
        {
          if (!connections.Contains(this.rootDirectoryValue))
          {
            infoEvents.FireError(0, "ForEachDirectory", "The ConnectionManager " + this.rootDirectoryValue + " does not exist in the collection.", "", 0);
            return DTSExecResult.Failure;
          }
        }
        else if (this.rootDirectorySourceValue == RootDirectorySource.Variable)
        {
          if (!variableDispenser.Contains(this.rootDirectoryValue))
          {
            infoEvents.FireError(0, "ForEachDirectory", "The Variable " + this.rootDirectoryValue + " does not exist in the collection.", "", 0);
            return DTSExecResult.Failure;
          }
        }

        /// Verify that a root directory is specified.
        if (this.rootDirectoryValue.Length < 1)
        {
          infoEvents.FireError(0, "ForEachDirectory", "The RootDirectory is configured to use " + this.rootDirectorySourceValue.ToString() + " but no value is specified.", "", 0);
        }
      }
      catch (System.Exception e)
      {
        infoEvents.FireError(0, "ForEachDirectory", e.Message, "", 0);
        return DTSExecResult.Failure;
      }
      return DTSExecResult.Success;
    }
    #endregion

    #region GetEnumerator
    /// <summary>
    /// This method is called by the ForEachLoop container during execution. An object that implements IEnumerable
    /// must be returned, which the ForEachLoop then iterates, and provides the value of each object in the
    /// enumeratedValue variable that is available to the control flow contained by the For Each Loop.
    /// </summary>
    /// <param name="connections">The collection of ConnectionManagers in the package.</param>
    /// <param name="variableDispenser">A VariableDispenser used to read and write variables in the package.</param>
    /// <param name="events">Used to fire events.</param>
    /// <param name="log">Used to write log entries.</param>
    /// <returns>An object that implements IEnumerable.</returns>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
    public override object GetEnumerator(Connections connections, VariableDispenser variableDispenser, IDTSInfoEvents events, IDTSLogging log)
    {
      if (connections == null)
      {
        throw new ArgumentNullException("connections");
      }

      if (variableDispenser == null)
      {
        throw new ArgumentNullException("variableDispenser");
      }

      if (events == null)
      {
        throw new ArgumentNullException("events");
      }

      try
      {
        string rootDir = "";

        directories = new ArrayList();

        if (this.rootDirectorySourceValue == RootDirectorySource.ConnectionManager)
        {
          rootDir = connections[this.rootDirectoryValue].AcquireConnection(null) as string;
        }
        else if (this.rootDirectorySourceValue == RootDirectorySource.Variable)
        {
          Variables vars = null;
          variableDispenser.LockOneForRead(this.rootDirectoryValue, ref vars);
          rootDir = vars[this.rootDirectoryValue].Value.ToString();
          vars.Unlock();
        }
        else
        {
          rootDir = this.rootDirectoryValue;
        }

        if (rootDir.Length != 0 && Directory.Exists(rootDir))
        {
          AddDirectory(new DirectoryInfo(rootDir), this.includeRootDirectoryValue);
          return directories.GetEnumerator();
        }
        else
        {
          events.FireError(0, "ForEachDirectory", "The RootDirectory is not provided or does not exist.", "", 0);
          return null;
        }
      }
      catch (System.Exception e)
      {
        events.FireError(0, "ForEachDirectory", e.Message, "", 0);
        return null;
      }
    }
    #endregion

    #region IDTSComponentPersist Members
    /// <summary>
    /// This method is called when the Enumerator is saved being saved. The Runtime provides a partial xml document
    /// that is used to persist information about the enumerator. For each of the properties of the
    /// enumerator an XmlElement is created and the value of the property is persisted in the
    /// InnerText property of th element.
    /// </summary>
    /// <param name="doc">The partial xml document provided by the runtime. After this method
    /// returns the DTS runtime incorporates the document into the package XML document</param>
    /// <param name="infoEvents">The IDTSInfoevents interface that can be used to provide information 
    /// during persistence.</param>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
    public void SaveToXML(System.Xml.XmlDocument doc, IDTSInfoEvents infoEvents)
    {
      if (doc == null)
      {
        throw new ArgumentNullException("doc");
      }

      if (infoEvents == null)
      {
        throw new ArgumentNullException("infoEvents");
      }

      try
      {
        XmlElement eForEachDir = doc.CreateElement("ForEachDirectory");

        XmlElement eDirectory = doc.CreateElement("RootDirectory");
        eDirectory.InnerText = this.rootDirectoryValue;
        eForEachDir.AppendChild(eDirectory);

        XmlElement eIncludeRootDir = doc.CreateElement("IncludeRootDirectory");
        eIncludeRootDir.InnerText = this.includeRootDirectoryValue.ToString();
        eForEachDir.AppendChild(eIncludeRootDir);

        XmlElement eEnumerateSubFolders = doc.CreateElement("EnumerateSubFolders");
        eEnumerateSubFolders.InnerText = this.enumerateSubFoldersValue.ToString();
        eForEachDir.AppendChild(eEnumerateSubFolders);

        XmlElement eRootDirectorySource = doc.CreateElement("RootDirectorySource");
        eRootDirectorySource.InnerText = ((int)this.rootDirectorySourceValue).ToString(System.Globalization.CultureInfo.InstalledUICulture);
        eForEachDir.AppendChild(eRootDirectorySource);

        XmlElement eSiblingFoldersBeforeSubFolders = doc.CreateElement("SiblingFoldersBeforeSubFolders");
        eSiblingFoldersBeforeSubFolders.InnerText = this.siblingFoldersBeforeSubFoldersValue.ToString();
        eForEachDir.AppendChild(eSiblingFoldersBeforeSubFolders);

        doc.AppendChild(eForEachDir);
      }
      catch (System.Exception e)
      {
        infoEvents.FireError(0, "ForEachDirectory", e.Message, "", 0);
      }
    }
    /// <summary>
    /// This method is called when the Enumerator is being loaded in a package. The runtime provides
    /// the XmlElement that is created during the SaveToXml method. The properties of the enumerator
    /// are initialized to the values persisted in the xml element.
    /// </summary>
    /// <param name="node">The XmlElement containing the enumerator information.</param>
    /// <param name="infoEvents">An IDTSInfoEvents that is used to provide information during serialization.</param>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
    public void LoadFromXML(System.Xml.XmlElement node, IDTSInfoEvents infoEvents)
    {
      if (node == null)
      {
        throw new ArgumentNullException("node");
      }

      if (infoEvents == null)
      {
        throw new ArgumentNullException("infoEvents");
      }

      try
      {
        this.rootDirectoryValue = node["RootDirectory"].InnerText;
        this.enumerateSubFoldersValue = Convert.ToBoolean(node["EnumerateSubFolders"].InnerText,
            System.Globalization.CultureInfo.InvariantCulture);
        this.includeRootDirectoryValue = Convert.ToBoolean(node["IncludeRootDirectory"].InnerText,
            System.Globalization.CultureInfo.InvariantCulture);
        this.siblingFoldersBeforeSubFoldersValue = Convert.ToBoolean(node["SiblingFoldersBeforeSubFolders"].InnerText,
            System.Globalization.CultureInfo.InvariantCulture);
        this.rootDirectorySourceValue = (ForEachDirectory.RootDirectorySource)(Convert.ToInt32(node["RootDirectorySource"].InnerText,
            System.Globalization.CultureInfo.InvariantCulture));
      }
      catch (System.Exception e)
      {
        infoEvents.FireError(0, "ForEachDirectory", e.Message, "", 0);
      }

    }

    #endregion

    #region AddDirectory
    /// <summary>
    /// Adds the directories contained in the provided DirectoryInfo parameter. Based on the 
    /// settings of the enumerator, this method is called recursively to add the subfolders of the subfolders.
    /// </summary>
    /// <param name="dirInfoParent">The directory that is added to the directories array.</param>
    /// <param name="addParent">Specifies whether to add the DirectoryInfo to the list, or just the subfolders.</param>
    private void AddDirectory(DirectoryInfo dirInfoParent, bool addParent)
    {
      DirectoryInfo[] dirInfoChildren = dirInfoParent.GetDirectories();

      /// Add the parent.
      if (addParent)
        directories.Add(dirInfoParent.FullName);

      /// Add the subfolders of the parent.
      foreach (DirectoryInfo dirInfoChild in dirInfoChildren)
      {
        directories.Add(dirInfoChild.FullName);

        if (this.enumerateSubFoldersValue && !this.siblingFoldersBeforeSubFoldersValue)
        {
          /// Subfolders of the subfolder, or the sibling folders and then subfolders?
          AddDirectory(dirInfoChild, false);
        }
      }

      /// Sibling folders before the subfolders folders, so now that the siblings
      /// have been added, add the children of the siblings.
      if (this.enumerateSubFoldersValue && this.siblingFoldersBeforeSubFoldersValue)
      {
        foreach (DirectoryInfo dirInfoChild in dirInfoChildren)
          AddDirectory(dirInfoChild, false);
      }
    }
    #endregion
  }
}
