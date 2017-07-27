///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2017, Brian Hansen(brian at tf3604.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

namespace ThinkInSetsGui
{
    partial class ThinkInSetsMainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.currentTestLabel = new System.Windows.Forms.Label();
            this.currentTestTestBox = new System.Windows.Forms.TextBox();
            this.changeTestButton = new System.Windows.Forms.Button();
            this.startButton = new System.Windows.Forms.Button();
            this.cancelButton = new System.Windows.Forms.Button();
            this.resultsLabel = new System.Windows.Forms.Label();
            this.resultsGrid = new System.Windows.Forms.DataGridView();
            this.averageRunTimeLabel = new System.Windows.Forms.Label();
            this.averageRunTimeTextBox = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.resultsGrid)).BeginInit();
            this.SuspendLayout();
            // 
            // currentTestLabel
            // 
            this.currentTestLabel.AutoSize = true;
            this.currentTestLabel.Location = new System.Drawing.Point(13, 13);
            this.currentTestLabel.Name = "currentTestLabel";
            this.currentTestLabel.Size = new System.Drawing.Size(61, 13);
            this.currentTestLabel.TabIndex = 0;
            this.currentTestLabel.Text = "Current test";
            // 
            // currentTestTestBox
            // 
            this.currentTestTestBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.currentTestTestBox.Location = new System.Drawing.Point(80, 10);
            this.currentTestTestBox.Name = "currentTestTestBox";
            this.currentTestTestBox.ReadOnly = true;
            this.currentTestTestBox.Size = new System.Drawing.Size(356, 20);
            this.currentTestTestBox.TabIndex = 1;
            // 
            // changeTestButton
            // 
            this.changeTestButton.Location = new System.Drawing.Point(57, 39);
            this.changeTestButton.Name = "changeTestButton";
            this.changeTestButton.Size = new System.Drawing.Size(123, 23);
            this.changeTestButton.TabIndex = 2;
            this.changeTestButton.Text = "Change Test ...";
            this.changeTestButton.UseVisualStyleBackColor = true;
            // 
            // startButton
            // 
            this.startButton.Enabled = false;
            this.startButton.Location = new System.Drawing.Point(187, 40);
            this.startButton.Name = "startButton";
            this.startButton.Size = new System.Drawing.Size(75, 23);
            this.startButton.TabIndex = 3;
            this.startButton.Text = "Start";
            this.startButton.UseVisualStyleBackColor = true;
            // 
            // cancelButton
            // 
            this.cancelButton.Enabled = false;
            this.cancelButton.Location = new System.Drawing.Point(268, 40);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 4;
            this.cancelButton.Text = "Cancel";
            this.cancelButton.UseVisualStyleBackColor = true;
            // 
            // resultsLabel
            // 
            this.resultsLabel.AutoSize = true;
            this.resultsLabel.Location = new System.Drawing.Point(16, 83);
            this.resultsLabel.Name = "resultsLabel";
            this.resultsLabel.Size = new System.Drawing.Size(42, 13);
            this.resultsLabel.TabIndex = 5;
            this.resultsLabel.Text = "Results";
            // 
            // resultsGrid
            // 
            this.resultsGrid.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.resultsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.resultsGrid.Location = new System.Drawing.Point(19, 113);
            this.resultsGrid.Name = "resultsGrid";
            this.resultsGrid.Size = new System.Drawing.Size(417, 226);
            this.resultsGrid.TabIndex = 6;
            // 
            // averageRunTimeLabel
            // 
            this.averageRunTimeLabel.AutoSize = true;
            this.averageRunTimeLabel.Location = new System.Drawing.Point(19, 356);
            this.averageRunTimeLabel.Name = "averageRunTimeLabel";
            this.averageRunTimeLabel.Size = new System.Drawing.Size(87, 13);
            this.averageRunTimeLabel.TabIndex = 7;
            this.averageRunTimeLabel.Text = "Average run time";
            // 
            // averageRunTimeTextBox
            // 
            this.averageRunTimeTextBox.Location = new System.Drawing.Point(133, 353);
            this.averageRunTimeTextBox.Name = "averageRunTimeTextBox";
            this.averageRunTimeTextBox.ReadOnly = true;
            this.averageRunTimeTextBox.Size = new System.Drawing.Size(100, 20);
            this.averageRunTimeTextBox.TabIndex = 8;
            // 
            // ThinkInSetsMainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(460, 383);
            this.Controls.Add(this.averageRunTimeTextBox);
            this.Controls.Add(this.averageRunTimeLabel);
            this.Controls.Add(this.resultsGrid);
            this.Controls.Add(this.resultsLabel);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.startButton);
            this.Controls.Add(this.changeTestButton);
            this.Controls.Add(this.currentTestTestBox);
            this.Controls.Add(this.currentTestLabel);
            this.MinimumSize = new System.Drawing.Size(400, 350);
            this.Name = "ThinkInSetsMainForm";
            this.Text = "Think in Sets Test Harness";
            ((System.ComponentModel.ISupportInitialize)(this.resultsGrid)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label currentTestLabel;
        private System.Windows.Forms.TextBox currentTestTestBox;
        private System.Windows.Forms.Button changeTestButton;
        private System.Windows.Forms.Button startButton;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.Label resultsLabel;
        private System.Windows.Forms.DataGridView resultsGrid;
        private System.Windows.Forms.Label averageRunTimeLabel;
        private System.Windows.Forms.TextBox averageRunTimeTextBox;
    }
}

